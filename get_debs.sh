#!/bin/bash
cd $(dirname $0)/debs
sudo apt-get update -q
#packages=$(apt-cache -q search ros-indigo | head -n 2 | cut -f 1 -d " ") # for test
packages=$(apt-cache -q search ros-indigo | cut -f 1 -d " ")
apt-get download $packages
