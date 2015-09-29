#!/bin/bash

ls -al
sudo apt-get install ros-indigo-*
./scripts/generator.py indigo
mkdir -p _build
cd doc
for a in $(ls); do
    if [ -e $$a/conf.py ]; then
        pushd $$a
        sphinx-build -E -b html . ../../_build/$$a
        popd
    fi
done

