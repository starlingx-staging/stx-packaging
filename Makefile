PKG ?= "x.stx-fault/fm-common"
DISTRO ?= "ubuntu"
ISO_TEMPLATE ?= ""


all:
	@echo "Check all the options to build"
image:
	@echo "Creating image .img to boot and test"
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
	sudo rm -rf /var/cache/pbuilder/result/*.deb
	cd upstream_pkgs/$(PKG) && sudo pbuilder build --override-config *.dsc
	- sudo cp -rf /var/cache/pbuilder/result/*.deb upstream_pkgs/$(PKG)/results/
	- sudo cp upstream_pkgs/$(PKG)/results/*.deb /usr/local/mydebs/

distclean_upstream_pkg:
	sudo rm -rf upstream_pkgs/$(PKG)
newpackage:
	@echo "Building new package $(PKG)"
clean:
	cd $(PKG)/$(DISTRO) && make clean
	rm -rf ubuntu.iso
