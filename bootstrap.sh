#!/usr/bin/env bash

set -euo pipefail

# move to the configuration directory, wherever that is
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
cd $dir

# we infer the architecture in this parent file,
# so that each of the helper files below knows what
# binaries it has to retrieve, if any
name=$(uname)
if [ $name = "Darwin" ]; then
    arch="macos"
elif [ $name = "Linux" ]; then
    arch="linux"
else
    echo "Unsupported platform ${uname}"
fi

ARCH=${arch} ./bootstrapping/bootstrap_plug.sh
ARCH=${arch} ./bootstrapping/bootstrap_python.sh

touch .bootstrap_sentinel
