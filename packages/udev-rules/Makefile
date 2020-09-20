PACKAGE_NAME=udev-rules

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed:
	mkdir -p $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)
	cp -f *.rules $(SYSROOT)$(ENGINE_PATH)/etc/udev/rules.d
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed

all: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed