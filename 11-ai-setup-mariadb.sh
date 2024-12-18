#!/bin/sh

sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# Two all-privilege accounts were created.
# One is root@localhost, it has no password, but you need to
# be system 'root' user to connect. Use, for example, sudo mysql
# The second is mysql@localhost, it has no password either, but
# you need to be the system 'mysql' user to connect.
# After connecting you can set the password, if you would need to be
# able to connect as any of these users with a password and without sudo

sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service

sudo mysql -u root -p
# MariaDB> CREATE USER 'fj'@'localhost' IDENTIFIED BY 'password';
# MariaDB> GRANT ALL PRIVILEGES ON mydb.* TO 'fj'@'localhost';
# MariaDB> GRANT ALL PRIVILEGES ON *.* TO 'fj'@'localhost';
# MariaDB> FLUSH PRIVILEGES;
# MariaDB> quit

mysql -u fj -ppassword -h localhost mysql

scp dsadmin@baptist:/home/dsadmin/Documents/ServerDocuments/Backups/MySql/{dbdata01.tgz,dbdump01.tgz} /home/fj/big-files/
cd /home/fj/big-files/ || exit 1
tar xzf dbdata01.tgz
tar xzf dbdump01.tgz
mv /home/fj/big-files/home/dsadmin/Documents/ServerDocuments/Backups/MySql/scratch /home/fj/big-files/sql_dump
mv /home/fj/big-files/var/lib/mysql /home/fj/big-files/var_lib_mysql
rm -rf /home/fj/big-files/{home,var,dbdata01.tgz,dbdump01.tgz}

mysql -u fj -ppassword -h localhost mysql
# MariaDB> create database wstrueorthodoxy;
mysql -v -h localhost -u fj -ppassword wstrueorthodoxy < /home/fj/big-files/sql_dump/wstrueorthodoxy.sql

/home/fj/bak/projects/calendar-gen-full-year-detailed/db-fixes/rebuild-all.sh
