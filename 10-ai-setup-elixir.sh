#!/bin/sh

# asdf plugin-list-all | rg elixir

asdf plugin add erlang
asdf plugin add elixir

asdf list
asdf list elixir
asdf list-all elixir

# fj@myr ~> asdf latest elixir
# 1.17.3-otp-27
# fj@myr ~> asdf latest erlang

asdf install erlang latest

# install elixir manually, to get go-to def working on stdlib
# cf. https://mister11.dev/posts/fixing_go_to_definition_in_elixir_stdlib/
# https://github.com/elixir-lang/elixir/tags

cd ~/src/elixir || exit 1
make clean
git checkout v1.17.3
make
asdf global elixir path:/home/fj/src/elixir

# using lexical instead of elixir-ls...keeps having problems in emacs
# cd ~/src/elixir-ls || exit 1
# git checkout v0.24.1
# mix deps.get
# MIX_ENV=prod mix compile
# MIX_ENV=prod mix elixir_ls.release2 -o /home/fj/src/elixir-ls/release
# asdf global elixir-ls path:/home/fj/src/elixir-ls

asdf plugin-update --all
# asdf update # use pacman to update asdf

asdf global elixir 1.17.3-otp-27
asdf global erlang 27.1.2
# asdf global elixir-ls 0.24.1

asdf list

# asdf local elixir 1.17.3-otp-27
# asdf local erlang 27.1.2

# fj@myr ~> which elixir
# /home/fj/.asdf/shims/elixir

# cd ~/src || exit 1
# git clone git@github.com:lexical-lsp/lexical.git
# cd lexical || exit 1
# mix deps.get
# mix package
