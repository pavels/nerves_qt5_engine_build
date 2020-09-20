PACKAGE_NAME=fonts

ESCAPED_ENGINE_PATH=$(shell printf '%s\n' "$(ENGINE_PATH)" | sed -e 's/[\/&]/\\&/g' )

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed:
	mkdir -p $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)
	cp -rf fonts $(SYSROOT)$(ENGINE_PATH)/share
	cp local.conf $(SYSROOT)$(ENGINE_PATH)/etc/fonts
	sed -i "s/@PREFIX@/${ESCAPED_ENGINE_PATH}/g;" $(SYSROOT)$(ENGINE_PATH)/etc/fonts/local.conf
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed

all: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed
