#!/usr/bin/env bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
curl \
    --fail \
    --location \
    --create-dirs \
    --output $dir/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
