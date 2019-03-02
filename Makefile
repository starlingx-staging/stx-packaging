PKG ?= "fault/fm-common"
DISTRO?= "ubuntu"

all:
	@echo "Check all the options to build"
image:
	@echo "Creating image .img to boot and test"
iso:
	@echo "Creating image .iso to boot and test"
package:
	@echo "Building package $(PKG) for $(DISTRO)"
	cd $(PKG)/$(DISTRO) && make
newpackage:
	@echo "Building new package $(PKG)"
clean:
	cd $(PKG)/$(DISTRO) && make clean
