SRC ?= "https://git.starlingx.io/stx-fault"
NAME ?= "fm-common"
SUB_DIR ?= "fm-common/sources"
DEBMAKE ?= "python"
all:
	../../../autodeb/autodeb/autodeb -u $(SRC) -n $(NAME) -d $(SUB_DIR) -b $(DEBMAKE)
clean:
	rm -rf *.tar.gz
	rm -rf $(NAME)-0.0/
	rm -rf *.deb
	rm -rf *.debian.tar.xz
	rm -rf *orig.tar.gz
	rm -rf *_amd64.changes
	rm -rf *.dsc
