#!/usr/bin/env bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
curl \
    --fail \
    --location \
    --create-dirs \
    --output $dir/bin/nvim-macos.tar.gz \
    https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar -xf $dir/bin/nvim-macos.tar.gz --directory $dir/bin

if [ -f ~/bin/nvim ]; then
    rm ~/bin/nvim
fi
ln -s $dir/bin/nvim-osx64/bin/nvim ~/bin/nvim
