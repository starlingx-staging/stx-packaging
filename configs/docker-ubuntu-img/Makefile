all:
	docker build -t ubuntu-stx:v1 .
run:
	docker run -it --privileged ubuntu-stx:v1 /bin/bash
test:
	docker run -it --privileged ubuntu-stx:v1 /bin/bash -c 'cd stx-packaging; ./setup.sh && make testbuild'
distclean:
	docker rmi -f ubuntu-stx:v1

