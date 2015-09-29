#!/bin/bash
cd $(dirname $0)
ls -al
sudo apt-get update
sudo apt-get install -f python-pip aptitude
sudo aptitude install -f ros-indigo-*
sudo pip install -r requirements.txt
sudo pip install git+https://github.com/otamachan2/sphinxcontrib-ros.git
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

