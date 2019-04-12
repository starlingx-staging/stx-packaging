PKG ?="x.stx-fault/fm-common"

DOCKER_BUILD_ARGS := --build-arg http_proxy --build-arg https_proxy --build-arg no_proxy \
		--build-arg HTTP_PROXY --build-arg HTTPS_PROXY --build-arg NO_PROXY

DOCKER_RUN_ARGS := --privileged -v $(PWD)/results:/usr/local/mydebs
DOCKER_RUN_ARGS += --rm
DOCKER_RUN_ARGS += --env http_proxy --env https_proxy --env no_proxy \
		--env HTTP_PROXY --env HTTPS_PROXY --env NO_PROXY
all:
	[ ! -z $(docker images -q ubuntu-stx:v1) ] || docker build $(DOCKER_BUILD_ARGS) -t ubuntu-stx:v1 .
run:
	docker run -it $(DOCKER_RUN_ARGS) ubuntu-stx:v1 /bin/bash
test:
	docker run -it $(DOCKER_RUN_ARGS) ubuntu-stx:v1 /bin/bash -c './setup.sh && make testbuild'
package:
	docker run -it $(DOCKER_RUN_ARGS) ubuntu-stx:v1 /bin/bash -c './setup.sh && make package PKG=$(PKG) DISTRO=ubuntu'
upstream_pkg:
	docker run -it $(DOCKER_RUN_ARGS) ubuntu-stx:v1 /bin/bash -c './setup.sh && make upstream_pkg PKG=$(PKG) DISTRO=ubuntu'
distclean:
	docker rmi -f ubuntu-stx:v1

