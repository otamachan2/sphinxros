#!/bin/bash
cd $(dirname $0)
# download
sudo apt-get update -q
#packages=$(apt-cache -q search ros-indigo | cut -f 1 -d " ")
packages=$(apt-cache -q search ros-indigo | head -n 2 | cut -f 1 -d " ")
cd debs
apt-get download $packages
