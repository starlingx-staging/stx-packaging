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
newpackage:
	@echo "Building new package $(PKG)"
clean:
	cd $(PKG)/$(DISTRO) && make clean
	rm -rf ubuntu.iso
