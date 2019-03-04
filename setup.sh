#!/usr/bin/env bash

if [ ! -d "autodeb" ] ; then
    git clone --depth=1 https://github.com/VictorRodriguez/autodeb.git
fi

# clone Flock services

if [ ! -d "x.stx-fault" ] ; then
    git clone -b poc_ubuntu_build --depth=1 https://github.com/VictorRodriguez/x.stx-fault.git
fi

echo "Set up complete"
