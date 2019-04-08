PKG ?= "x.stx-fault/fm-common"
DISTRO ?= "ubuntu"
ISO_TEMPLATE ?= ""
BUILD_W_CONT ?= "n"


all:
	@echo "Check all the options to build"
iso:
	@ echo "Creating image .iso to boot and test"
	cp $(ISO_TEMPLATE) linuxbuilder/
	cp -rf /usr/local/mydebs/*.deb linuxbuilder/DEBS/
	cd linuxbuilder/ && make iso-ubuntu IMAGE=$(ISO_TEMPLATE)
	mv linuxbuilder/ubuntu.iso .
liveimg:
	@ echo "Creating $(DISTRO) live image"
	cp -rf /usr/local/mydebs/*.deb live_img/$(DISTRO)/stxdebs/
	@ cd live_img/ && make DISTRO=$(DISTRO)

build_cont_img:
	cd configs/docker-$(DISTRO)-img/ && make
build_pkg_in_cont:
	cd configs/docker-$(DISTRO)-img/ && make package PKG=$(PKG)
build_pkg_native:
	@echo "Compiing w/o contianers in a native $(DISTRO) system"
	@echo "Building package $(PKG) for $(DISTRO)"
	cd $(PKG)/$(DISTRO) && make

package:
ifeq ($(BUILD_W_CONT),y)
package:build_cont_img build_pkg_in_cont
else
package:build_pkg_native
endif

upstream_pkg:
	@echo "Building package $(PKG) for $(DISTRO)"
	- mkdir -p upstream_pkgs/$(PKG)
	- mkdir -p upstream_pkgs/$(PKG)/results
	cd upstream_pkgs/$(PKG) && sudo apt-get source $(PKG)
	cp configs/generic-Makefile upstream_pkgs/$(PKG)/Makefile
	cd upstream_pkgs/$(PKG) && make
clean_upstream_pkg:
	cd upstream_pkgs/$(PKG) && make clean
distclean_upstream_pkg:
	sudo rm -rf upstream_pkgs/$(PKG)
testbuild: package
	@ if [ $$? -eq 0 ] ; then echo "Test Build: OK !"; fi
update:
	sudo pbuilder update --components "main universe" --override-config
clean:
	cd $(PKG)/$(DISTRO) && make clean
	rm -rf ubuntu.iso
