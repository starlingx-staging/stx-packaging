PKG ?= "x.stx-fault/fm-common"
DISTRO ?= "ubuntu"
ISO_TEMPLATE ?= ""


all:
	@echo "Check all the options to build"
iso:
	@ echo "Creating image .iso to boot and test"
	cp $(ISO_TEMPLATE) linuxbuilder/
	cp -rf /usr/local/mydebs/*.deb linuxbuilder/DEBS/
	cd linuxbuilder/ && make iso-ubuntu IMAGE=$(ISO_TEMPLATE)
	mv linuxbuilder/ubuntu.iso .
package:
	@echo "Building package $(PKG) for $(DISTRO)"
	cd $(PKG)/$(DISTRO) && make
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
	if [ $$? -eq 0 ] ; then echo "Test Build: OK !"; fi
clean:
	cd $(PKG)/$(DISTRO) && make clean
	rm -rf ubuntu.iso
