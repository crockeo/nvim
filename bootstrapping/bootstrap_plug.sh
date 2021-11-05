#!/usr/bin/env bash

set -euo pipefail

curl \
    --fail \
    --location \
    --create-dirs \
    --output $(pwd)/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
