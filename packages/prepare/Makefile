PACKAGE_NAME=prepare

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed:
	mkdir -p $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)
	cd $(NERVES_BUILD_DIR) && ln -s $(NERVES_SYSTEM_IMAGE_DIR)/staging/$(ENGINE_PATH) qt5-engine
	cd $(NERVES_BUILD_DIR) && ln -s qt5/host-tools qt5-host-tools
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed

all: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed
