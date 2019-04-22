#!/usr/bin/env bash

if ! type "debmake" > /dev/null; then
    sudo apt-get install -y debmake
fi

if ! type "pbuilder" > /dev/null; then
    sudo apt-get install -y pbuilder
fi

if ! type "dpkg-scanpackages" > /dev/null; then
    sudo apt-get install -y dpkg-dev
fi

if [ ! -f /var/cache/pbuilder/base.tgz ] ; then
    sudo pbuilder create
fi

if [ ! -d "/usr/lib/grub/i386-pc" ]; then
    sudo apt-get install -y grub-pc
fi

sudo mkdir -p /usr/local/mydebs/
sudo mkdir -p /var/cache/pbuilder/hook.d/

cp configs/pbuilderrc ~/.pbuilderrc
sudo cp configs/D70results /var/cache/pbuilder/hook.d/

