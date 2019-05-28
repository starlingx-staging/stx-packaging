PKG ?="x.stx-fault/fm-common"

DOCKER_BUILD_ARGS := --build-arg http_proxy --build-arg https_proxy --build-arg no_proxy \
		--build-arg HTTP_PROXY --build-arg HTTPS_PROXY --build-arg NO_PROXY

DOCKER_RUN_ARGS := --privileged -v $(PWD)/results:/usr/local/mydebs
DOCKER_RUN_ARGS += -v $(PWD)/../../:/stx-packaging
ifeq ($(filter-out Linux, $(shell uname)),)
DOCKER_RUN_ARGS += -v $(PWD)/pbuilder:/var/cache/pbuilder
endif
DOCKER_RUN_ARGS += --rm
DOCKER_RUN_ARGS += --env http_proxy --env https_proxy --env no_proxy \
		--env HTTP_PROXY --env HTTPS_PROXY --env NO_PROXY
all:
	[ ! -z $(docker images -q debian-stx:v1) ] || docker build $(DOCKER_BUILD_ARGS) -t debian-stx:v1 .
run:
	docker run -it $(DOCKER_RUN_ARGS) debian-stx:v1 /bin/bash
test:
	docker run -it $(DOCKER_RUN_ARGS) debian-stx:v1 /bin/bash -c './setup.sh && make testbuild'
package:
	docker run -it $(DOCKER_RUN_ARGS) debian-stx:v1 /bin/bash -c './setup.sh && make package PKG=$(PKG) DISTRO=debian'
upstream_pkg:
	docker run -it $(DOCKER_RUN_ARGS) debian-stx:v1 /bin/bash -c './setup.sh && make upstream_pkg PKG=$(PKG) DISTRO=debian'
distclean:
	docker rmi -f debian-stx:v1

