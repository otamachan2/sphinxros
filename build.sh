#!/bin/bash
cd $(dirname $0)
ls -al
sudo apt-get update
sudo apt-get install -f -y python-pip
blacklists=(pepper naoqi nao romeo ipa-canopen shadow-robot)
packages=$(apt-cache -q search ros-indigo | cut -f 1 -d " " | grep -Ev $(IFS=\|; echo "${blacklists[*]}"))
packages=$(apt-cache -q search ros-indigo | head -n 2 | cut -f 1 -d " ")
mkdir debs
pushd debs
apt-get download $packages
for deb in `find . -iname '*.deb'`; do
    sudo dpkg --force-all -i $deb > /dev/null 2&>1
done
popd
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

