PKG ?= "x.stx-fault/fm-common"
DISTRO ?= "ubuntu"
ISO_TEMPLATE ?= "ubuntu-16.04.6-server-amd64.iso"


all:
	@echo "Check all the options to build"
image:
	@echo "Creating image .img to boot and test"
iso:
	@echo "Creating image .iso to boot and test"
	@if [ ! -f $(ISO_TEMPLATE) &&  ! -f linuxbuilder/$(ISO_TEMPLATE) ]; then \
		echo "Download image with";\
		echo "curl -O http://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-amd64.iso";\
	elif [ ! -f linuxbuilder/$(ISO_TEMPLATE) ]; then \
        cp ubuntu-16.04.6-server-amd64.iso linuxbuilder/; \
	else\
		echo "Ready to build";\
		cp -rf /usr/local/mydebs/*.deb linuxbuilder/DEBS/;\
		cd linuxbuilder/ && make iso-ubuntu;\
		mv ubuntu.iso ../;\
    fi
package:
	@echo "Building package $(PKG) for $(DISTRO)"
	cd $(PKG)/$(DISTRO) && make
newpackage:
	@echo "Building new package $(PKG)"
clean:
	cd $(PKG)/$(DISTRO) && make clean
	rm -rf ubuntu.iso
distclean:
	rm -rf x.stx-fault/
