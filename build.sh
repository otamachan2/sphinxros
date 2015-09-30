#!/bin/bash
set -xv
cd $(dirname $0)
ls -al
sudo apt-get update
sudo apt-get install -f -y python-pip
blacklists=(pepper naoqi nao romeo ipa-canopen shadow-robot)
packages=$(apt-cache -q search ros-indigo | cut -f 1 -d " " | grep -Ev $(IFS=\|; echo "${blacklists[*]}"))
sudo apt-get download $packages
sudo dpkg --force-all -i $packages
sudo pip install -r requirements.txt
sudo pip install git+https://github.com/otamachan2/sphinxcontrib-ros.git
mkdir doc/packages
./scripts/generator.py indigo doc/packages/
mkdir -p _build
cd doc
for a in $(ls); do
    if [ -e $$a/conf.py ]; then
        pushd $$a
        sphinx-build -E -b html . ../../_build/$$a
        popd
    fi
done

