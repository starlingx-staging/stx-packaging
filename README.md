# Starling X multi-os packaging

This project builds the necessary packages and the Linux ISO to host the
[Containerizing StarlingX
Infrastructure](https://wiki.openstack.org/wiki/Containerizing_StarlingX_Infrastructure)
As a POC this project works now for debian base OS to generate a debian base
image with parts of the Starling X software stack

## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites

The development tools and git repositories that you need are installed by
running setup.sh

```
bash setup.sh
```

If you are under a proxy in order to make pbuilder make use of your apt-cache,
you just need to set this

export http_proxy=http://your-proxy:8080/ in ~/.pbuilderrc

## Building

Here are some step by step series of examples that tell you how to get a
development env running according to different scenarios:

### Building a package provided by Starling X ( Flock service )

#### Set up git repository that host the source and build scripts

After executing setup.sh the repositories that we specify on the repo file are
downloaded, ie:

```
$ cat repos
https://github.com/VictorRodriguez/x.stx-fault.git,poc_debian_build
https://github.com/marcelarosalesj/x.stx-config.git,debian
```

This is a csv file with these fields:

	* git repo
	* branch

This gives the freedom to developers to host their own forks of Starling X git
repositories repos to work. This gives flexibility for developers in the
meantime that the Gerrit review is approved. Originally the repos file should
point to the official starling x Gerrit repositories.

```
$ cat repos
https://git.starlingx.io/stx-fault,master
https://git.starlingx.io/stx-config,master
```

#### Build the DEB file

Once we have clone the proper repository where the flock service is hosted, we
can build as:

```
make package PKG=fault/fm-common DISTRO=debian
```

	* PKG=path to the directory where our fm-common project lives
	* DISTRO= debian | centos | suse ( for now only works for debian )

Another example could be fm-mgr:

```
make package PKG=x.stx-fault/fm-mgr DISTRO=debian
```

One difference here is that fm-mgr depends on build time of fm-common that we
previously build, How to add a local build dependency to our build system in
chroot, in this case is as simple as edit the file:

```
$ cat x.stx-fault/fm-mgr/debian/build_deps
fm-common
```

The Makefile located in : x.stx-fault/fm-mgr/debian/Makefile will build first
fm-common in case we forgot to build it

After that it will copy the .deb generated into /usr/local/mydebs/ that is our
local mirror/mount point for pbuilder tool to search local build dependencies

If you are not in a Linux machine but it has docker and Makefile tools, you
still can build an STX DEB:

``` make package PKG=x.stx-fault/fm-mgr DISTRO=debian BUILD_W_CONT=y ```

The flag ```BUILD_W_CONT=y``` will create a docker image with all the enviroment
necesary to build the package and leave the results in:

```
stx-packaging $ ls configs/docker-debian-img/results/
Packages.gz			fm-common-dev_0.0-1_amd64.deb
```
As you can see you can also set there an specific Packages.gz that you prefer
with fixed packages versions for your build

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
~/stx-packaging/x.stx-upstream/openstack/python-horizon/debian
Makefile
```

We could even move to this directory and type make or from our root repo
directory build as usual:

```
make package PKG=x.stx-upstream/openstack/python-horizon/ DISTRO=debian
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

distclean completely with:

```
make distclean_upstream_pkg PKG=bc
```

Another example more useful than bc calculator is:

```
make upstream_pkg PKG=linux-source-4.15.0
```
```
make upstream_pkg PKG=keystone
```

Porting of functional Starling X patches located at:

* [0001-StarlingX-Death-of-Arbitrary-Process-Notification.patch](https://raw.githubusercontent.com/tajtli/lts/master/starlingx/v4.18/0001-StarlingX-Death-of-Arbitrary-Process-Notification.patch)
* [0002-StarlingX-Kernel-Threads-Compute-CPU-Affinity.patch](https://raw.githubusercontent.com/tajtli/lts/master/starlingx/v4.18/0002-StarlingX-Kernel-Threads-Compute-CPU-Affinity.patch)
* [0003-StarlingX-Kernel-Threads-Workqueues-IRQs.patch](https://raw.githubusercontent.com/tajtli/lts/master/starlingx/v4.18/0003-StarlingX-Kernel-Threads-Workqueues-IRQs.patch)
* [0004-StarlingX-Kernel-Threads-iSCSI.patch](https://raw.githubusercontent.com/tajtli/lts/master/starlingx/v4.18/0004-StarlingX-Kernel-Threads-iSCSI.patch)

In order to insert the patches to the kernel just copy them into this directory: 

```
stx-packaging/upstream_pkgs/linux-source-4.15.0/linux-4.15.0/debian/patches
```
And put a series file that indicates the order of applying


## Sanity Test cases

This repo has its own sanity test to check that everything works:

```
make testbuild
```
## Container for development

Inside configs/docker-debian-img there is a Dockerfile with a Makefile.

To create a Docker image to develop:

```
	make

	make run

	root@e82355206aab:/# cd stx-packaging/ && ./setup.sh
```

This will create the chroot with all the build set up for pbuilder

A sanity test is included as well:

```
	make test
```

This will run the container and execute ./setup.sh && build fm-common

## Known issues

* unknown python version. check setup.py

This is a common error when the setup.py of your source code does not include
any shebang line. The root cause of this bug release on the debmake file
[analyze.py](https://salsa.debian.org/debian/debmake/blob/devel/debmake/analyze.py#L302)

A valid workaround is to set a proper shebang into the setup.py of your source
file in the meantime that we work on a proper patch with debmake maintainer


## Architecture

Architecture slides and diagrams at this [google presentation](https://drive.google.com/open?id=1ck7vGH50AIAjUx9GNrIGtowG5qg7OYUBNdJyY-5ZvDc)
## Built With

* [pbuilder](https://wiki.debian.com/PbuilderHowto) - allows users to setup a
chroot environment for building debian packages *
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

STX community for great feedback during the conception of this POC
