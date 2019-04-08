PKG ?="x.stx-fault/fm-common"

all:
	docker build -t ubuntu-stx:v1 .
run:
	docker run -it --privileged -v $(PWD)/results:/usr/local/mydebs ubuntu-stx:v1 /bin/bash
test:
	docker run -it --privileged -v $(PWD)/results:/usr/local/mydebs ubuntu-stx:v1 /bin/bash -c './setup.sh && make testbuild'
package:
	docker run -it --privileged -v $(PWD)/results:/usr/local/mydebs ubuntu-stx:v1 /bin/bash -c './setup.sh && make package PKG=$(PKG) DISTRO=ubuntu'
distclean:
	docker rmi -f ubuntu-stx:v1

