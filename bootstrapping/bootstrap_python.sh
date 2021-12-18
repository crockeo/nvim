#!/usr/bin/env bash

set -euo pipefail

release_day="20211017"
base_url="https://github.com/indygreg/python-build-standalone/releases/download/${release_day}"
version="3.9.7"

raw_arch=$(uname -p)
if [[ ${raw_arch} == "arm" ]]; then
    architecture="aarch64"
elif [[ ${raw_arch} == "x86_64" ]]; then
    architecture="x86_64"
else
    echo "ERROR: unrecognized platform '${ARCH}'"
    exit 1
fi

uname=$(uname)
if [[ ${uname} == "Darwin" ]]; then
    platform="apple-darwin"
elif [[ ${uname} == "Linux" ]]; then
    platform="unknown-linux-gnu"
else
    echo "ERROR: unrecognized platform '${uname}'"
    exit 1
fi

url="${base_url}/cpython-${version}-${architecture}-${platform}-pgo-${release_day}T1616.tar.zst"
echo "$url"
curl \
    --fail \
    --location \
    --create-dirs \
    --output python.tar.zst \
    "${url}"

unzstd -f python.tar.zst
tar -xf python.tar

rm -rf ~/.config/nvim/venv
./python/install/bin/python3 -m venv ~/.config/nvim/venv
~/.config/nvim/venv/bin/pip install --upgrade \
    pip \
    setuptools
~/.config/nvim/venv/bin/pip install \
    black==20.8b1 \
    neovim==0.3.1 \
    six==1.16.0 \
    tasklib==2.3.0 \
    tree-sitter==0.19.0
