# Starling X multi os packaging

This project builds the necesary packages and the Linux ISO to host the
[Containerizing StarlingX
Infrastructure](https://wiki.openstack.org/wiki/Containerizing_StarlingX_Infrastructure)
As a POC this project works now for Ubunut 16 or latest as development machine
to generate an Ubuntu 16 image with the Starling X Infrastructure

## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites

The development tools and git repositories that you need are installed by
runing setup.sh

```
bash setup.sh
```

## Building

Here are some step by step series of examples that tell you how to get a
development env running acording to different scenarios:

### Building a package provided by Starling X ( Flock service )

#### Set up git repository that host the source and build scripts

After executing setup.sh the repositories that we specifies on the repo file are downloaded , ie:

```
$ cat repos
https://github.com/VictorRodriguez/x.stx-fault.git,poc_ubuntu_build
https://github.com/marcelarosalesj/x.stx-config.git,ubuntu
```

This is a csv file with these fields:

	* git repo
	* branch

This gives the freedom to developers to host their own forks of Starling X git
repositories repos to work. This gives flexibility for developers in the
meantime that the gerrir review is approved. Originally the repos file should
point to the oficial starling x gerrit repositories.

```
$ cat repos
https://git.starlingx.io/stx-fault,master
https://git.starlingx.io/stx-config,master
```

#### Build the DEB file

Once we have clone the proper repository where the flock service is hosted, we can build as:

```
make package PKG=x.stx-fault/fm-common DISTRO=ubuntu
```

	* PKG=path to the directory where our fm-common project lives
	* DISTRO= ubuntu | centos | suse ( for now only works for ubuntu )

Another example could be fm-mgr:

```
make package PKG=x.stx-fault/fm-mgr DISTRO=ubuntu
```

One difference here is that fm-mgr depends on build time of fm-common that we
previusly build, How to add a local build dependency to our build system in
chroot , in this case is as simple as eddit the file:

```
$ cat x.stx-fault/fm-mgr/ubuntu/build_deps
fm-common
```

The Makefile located in : x.stx-fault/fm-mgr/ubuntu/Makefile will build first
fm-common in case we forgot to build it

After that it will copy the .deb generated into /usr/local/mydebs/ that is our
local mirror / mount point for pbuilder tool to search local build dependencies

### Building a package tunned by Starling X ( Horizon for example )

Following the same approach from the section "Set up git repository that host
the source and build scripts" from above our repo file should look like:

```
$ cat repos
https://github.com/VictorRodriguez/x.stx-upstream.git,master
```

Once we have clone the repo we can see that inside there is a Makefile with the
proper patches and build instructions

```
~/stx-packaging/x.stx-upstream/openstack/python-horizon/ubuntu
Makefile
```

We could even move to this directory and type make or from our root repo
directory build as ussual:

```
make package PKG=x.stx-upstream/openstack/python-horizon/ DISTRO=ubuntu
```

### Building an upstream package (bc and kernel)

```
make upstream_pkg PKG=bc
```

This generates a directory:

```
upstream_pkgs/bc/
```

With a generic Makefile to reuse if you want to add personal patches to the
upstream package before adding it to:

* stx-integ
* stx-upstream

Clean (but not erase your patches) with:

```
make clean_upstream_pkg PKG=bc
```

Distclean completely with:

```
make distclean_upstream_pkg PKG=bc
```

Another example more useful than bc calculator is:

```
make upstream_pkg PKG=linux-source-4.15.0
```

Porting of functional Starling X patches located at:

* [0001-StarlingX-Death-of-Arbitrary-Process-Notification.patch](https://raw.githubusercontent.com/tajtli/lts/master/starlingx/v4.18/0001-StarlingX-Death-of-Arbitrary-Process-Notification.patch)
* [0002-StarlingX-Kernel-Threads-Compute-CPU-Affinity.patch](https://raw.githubusercontent.com/tajtli/lts/master/starlingx/v4.18/0002-StarlingX-Kernel-Threads-Compute-CPU-Affinity.patch)
* [0003-StarlingX-Kernel-Threads-Workqueues-IRQs.patch](https://raw.githubusercontent.com/tajtli/lts/master/starlingx/v4.18/0003-StarlingX-Kernel-Threads-Workqueues-IRQs.patch)
[0004-StarlingX-Kernel-Threads-iSCSI.patch](https://raw.githubusercontent.com/tajtli/lts/master/starlingx/v4.18/0004-StarlingX-Kernel-Threads-iSCSI.patch)

## Building and image (WIP as POC state now)

For now we are using
[linuxbuilder](https://github.com/VictorRodriguez/linuxbuilder) script to test
our package created on an upstream ubuntu image. However it has a lot of
limitations and we are on the transition to [live
build](http://complete.sisudoc.org/manual/html/live-manual/installation.ro.html#installing-live-build)
tool.

In the meantime to test that your DEB file coudl be installed on an Ubuntu
image you can follow the next steps:

Check that only one DEB that does not require runtime dependencies  exist on
/usr/local/mydebs/
```
wget http://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-amd64.iso
$ make iso ISO_TEMPLATE=ubuntu-16.04.6-server-amd64.iso
```
Check the StarlingX Ubuntu based ISO image has been created:

```
user@workstation:~/starlingx/stx-packaging$ ls ubuntu.iso
ubuntu.iso
```

### Virtual Machine Setup

Create a QEMU disk:
```
user@workstation:~/starlingx/stx-packaging$ qemu-img create disk.img +30G
```

Launch the generated StarlingX based Ubuntu image, select the following options:

* Language: English
* Installation Options: Install Custom Ubuntu Server

```
user@workstation:~/starlingx/stx-packaging$ qemu-system-x86_64 -enable-kvm -machine accel=kvm -hda disk.img -boot d -cdrom ubuntu.iso -m 22640
```

Once StarlingX based Ubuntu image has been installed, remove the ISO file and launch again the virtual machine:

```
user@workstation:~/starlingx/stx-packaging$ qemu-system-x86_64 -enable-kvm -machine accel=kvm -hda disk.img -m 22640
```

## Sanity Testscases

This repo has its own sanity test to check that everything works:

```
make testbuild
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [pbuilder](https://wiki.ubuntu.com/PbuilderHowto) - allows users to setup a
chroot environment for building Ubuntu packages *
* [debmake](https://www.debian.org/doc/manuals/debmake-doc/apa.en.html) - program
to make a Debian source package


## Versioning

We use [SemVer](http://semver.org/) for versioning.

## Authors

* **VictorRodriguez** - *Initial work* - [VictorRodriguez](https://github.com/VictorRodriguez)
* **Marcela Rosales** *Initial work* - [marcelarosalesj](https://github.com/marcelarosalesj)
* **Abraham Arce** *Initial work* - [xe1gyq](https://github.com/xe1gyq)

## License

This project is licensed under the Apache License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments


