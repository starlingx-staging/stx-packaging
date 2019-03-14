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

#### Set up git repository that host the source and build scripts


## Running the tests

This repo has its own sanity test to check that everything works:

```
	make testbuild
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds


## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **VictorRodriguez** - *Initial work* - [VictorRodriguez](https://github.com/VictorRodriguez)

## License

This project is licensed under the Apache License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments


