#!/usr/bin/env bash

curl \
    --fail \
    --location \
    --create-dirs \
    --output $(pwd)/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
