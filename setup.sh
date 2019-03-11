#!/usr/bin/env bash

sudo mkdir -p /usr/local/mydebs/
sudo mkdir -p /var/cache/pbuilder/hook.d/

cp configs/pbuilderrc ~/.pbuilderrc
sudo cp configs/D70results /var/cache/pbuilder/hook.d/

if [ ! -d "autodeb" ] ; then
    git clone --depth=1 https://github.com/VictorRodriguez/autodeb.git
fi

if [ ! -d "linuxbuilder" ] ; then
    git clone --depth=1 https://github.com/VictorRodriguez/linuxbuilder.git
fi

# clone source code repos on specific branches
filename='repos'
while read line; do
	GIT_REPO=$( echo $line | cut -d',' -f1)
	BRANCH=$( echo $line | cut -d',' -f2 )
	DIR=$( echo $GIT_REPO | cut -d '/' -f5 | cut -d '.' -f1-2)
	echo $DIR
	if [ ! -z $DIR ];then
		if [ ! -d "$DIR" ] ; then
			git clone -b $BRANCH --depth=1 $GIT_REPO
		fi
	fi
done < $filename
echo "Set up complete"
