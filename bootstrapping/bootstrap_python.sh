#!/usr/bin/env bash

# TODO: bootstrap a python3 installation

base_url="https://github.com/indygreg/python-build-standalone/releases/download/20210103"
version="3.9.1"
architecture="x86_64"
uname=$(uname)
if [[ ${uname} == "Darwin" ]]; then
    platform="apple-darwin"
elif [[ ${uname} == "Linux" ]]; then
    platform="unknown-linux-gnu"
else
    echo "ERROR: unrecognized platform '${ARCH}'"
    exit 1
fi

url="${base_url}/cpython-${version}-${architecture}-${platform}-pgo-20210103T1125.tar.zst"
curl \
    --fail \
    --location \
    --create-dirs \
    --output python.tar.zst \
    "${url}"

unzstd -f python.tar.zst
tar -xf python.tar

./python/install/bin/python3 -m venv ~/.config/nvim/venv
. ~/.config/nvim/venv/bin/activate
pip install \
    black==20.8b1 \
    neovim==0.3.1 \
    tree-sitter==0.19.0
deactivate
