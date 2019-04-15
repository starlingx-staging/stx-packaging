all:
	docker build -t centos-mock:latest .
run:
	docker run --privileged -e MOCK_CONFIG=epel-6-i386 \
		-e SOURCE_RPM=/rpmbuild/git-2.3.0-1.el7.centos.src.rpm \
		-v /tmp/rpmbuild:/rpmbuild centos-mock:latest
test:
	mkdir -p /tmp/rpmbuild
	sudo rm -rf /tmp/rpmbuild/git-2.3.0-1.el7.centos.src.rpm
	wget https://copr-be.cloud.fedoraproject.org/results/snoopotic/git-rpms/epel-7-x86_64/git-2.3.0-1.el6/git-2.3.0-1.el7.centos.src.rpm -P /tmp/rpmbuild/
	docker run --privileged -e MOCK_CONFIG=epel-6-i386 \
		-e SOURCE_RPM=/rpmbuild/git-2.3.0-1.el7.centos.src.rpm \
		-v /tmp/rpmbuild:/rpmbuild centos-mock:latest

clean:
	rm -rf /tmp/rpmbuild/output

