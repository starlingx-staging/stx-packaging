#!/usr/bin/env bash

if ! type "debmake" > /dev/null; then
    sudo apt-get install debmake
fi

if ! type "pbuilder" > /dev/null; then
    sudo apt-get install pbuilder
fi

if [ ! -f /var/cache/pbuilder/base.tgz ] ; then
    sudo pbuilder create
fi

sudo mkdir -p /usr/local/mydebs/
sudo mkdir -p /var/cache/pbuilder/hook.d/

cp configs/pbuilderrc ~/.pbuilderrc
sudo cp configs/D70results /var/cache/pbuilder/hook.d/

if [ ! -d "autodeb" ] ; then
    git clone --depth=1 https://github.com/VictorRodriguez/autodeb.git
else
    echo "Updating autodeb"
    cd autodeb/ && git pull
    cd ..
fi

if [ ! -d "linuxbuilder" ] ; then
    git clone --depth=1 https://github.com/VictorRodriguez/linuxbuilder.git
else
    echo "Updating linuxbuilder"
    cd linuxbuilder/ && git pull
    cd ..
fi

# clone source code repos on specific branches
filename='repos'
while IFS=, read GIT_REPO BRANCH; do
	DIR=$(basename $GIT_REPO .git)
	if [ ! -z $DIR ];then
		if [ ! -d "$DIR" ] ; then
			git clone -b $BRANCH --depth=1 $GIT_REPO
		fi
	fi
done < $filename
echo "Set up complete"
