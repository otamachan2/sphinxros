#!/bin/bash
ROSDISTRO=indigo
REPO=github.com/otamachan2/sphinxros.git
cd $(dirname $0)
# install
mkdir -p debs doc/packages
sudo apt-get update -q
sudo apt-get install -f -y -q python-pip
sudo pip install -r requirements.txt
sudo pip install git+https://github.com/otamachan2/sphinxcontrib-ros.git
packages=$(apt-cache -q search ros-indigo | cut -f 1 -d " ")
#packages=$(apt-cache -q search ros-indigo | head -n 2 | cut -f 1 -d " ")
pushd debs; apt-get download $packages; popd
for deb in `find debs -iname '*.deb'`; do
    echo $deb
    sudo dpkg --force-all -i $deb > /dev/null 2&>1
done
# generate docs
./scripts/generator.py $ROSDISTRO doc/packages
echo Building $(ls -1 doc/packages | wc -l) packages
git clone "https://$REPO" _build
git -C _build checkout gh-pages
rm _build/$ROSDISTRO -rf
sphinx-build -a -E -b html doc _build/$ROSDISTRO
# push
git -C _build config user.name "Travis CI"
git -C _build config user.email "otamachan@gmail.com"
git -C _build add indigo
git -C _build commit -m "Deploy to GitHub Pages"
git -C _build push --force --quiet "https://$(cat .GH_TOKEN)@${REPO}" > /dev/null 2>&1



