PKG ?= "git-2.3.0-1.el7.centos.src.rpm"
URL ?= "https://copr-be.cloud.fedoraproject.org/results/snoopotic/git-rpms/epel-7-x86_64/git-2.3.0-1.el6/git-2.3.0-1.el7.centos.src.rpm"
TMP_MOUNT ?= "/tmp/rpmbuild/"
MOCK_CONFIG ?= "epel-6-i386"
IMAGE_NAME ?= "centos-mock:latest"
PATH_TO_FILE=/tmp/rpmbuild/$(PKG)

export $(TMP_MOUNT)

all:
	docker build -t $(IMAGE_NAME) .


build:download
	@echo $(PKG)
	@echo $(URL)
	docker run --privileged -e MOCK_CONFIG=$(MOCK_CONFIG) \
		-e SOURCE_RPM=/rpmbuild/$(PKG) \
		-v $(TMP_MOUNT):/rpmbuild $(IMAGE_NAME)
test:download
	@echo $(PKG)
	@echo $(URL)
	docker run --privileged -e MOCK_CONFIG=$(MOCK_CONFIG) \
		-e SOURCE_RPM=/rpmbuild/$(PKG) \
		-v $(TMP_MOUNT):/rpmbuild $(IMAGE_NAME)
debug:
	@echo $(PKG)
	@echo $(URL)
	docker run --privileged -e MOCK_CONFIG=$(MOCK_CONFIG) \
		-e SOURCE_RPM=/rpmbuild/$(PKG) \
		-v $(TMP_MOUNT):/rpmbuild -it $(IMAGE_NAME) /bin/bash
clean:
	rm -rf /tmp/rpmbuild/output

download:
	@if test -f $(PATH_TO_FILE); then echo exists; else wget $(URL) -P $(TMP_MOUNT); fi


