FROM ubuntu
RUN apt-get update && apt-get install -y \
	git \
	sudo \
	vim \
	debmake \
	pbuilder
# cp due to https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=858614
COPY ./para.py /usr/lib/python3/dist-packages/debmake/para.py
RUN git clone https://github.com/starlingx-staging/stx-packaging.git
RUN sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

