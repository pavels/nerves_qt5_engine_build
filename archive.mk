ifndef NERVES_ARCHIVE_NAME
$(error NERVES_ARCHIVE_NAME is not set)
endif

PACKAGING_DIR=$(NERVES_BUILD_DIR)/tmp-package
ARCHIVE_DIR=$(PACKAGING_DIR)/$(NERVES_ARCHIVE_NAME)

.PHONY: archive

archive:
	rm -rf "$(PACKAGING_DIR)"
	mkdir -p "$(ARCHIVE_DIR)"
	cp -HR "$(SYSROOT)$(ENGINE_PATH)" "$(ARCHIVE_DIR)/qt5-engine"
	cp -HR "$(NERVES_BUILD_DIR)/qt5/host-tools" "$(ARCHIVE_DIR)/qt5-host-tools"
	tar c -z -f "$(NERVES_BUILD_DIR)/$(NERVES_ARCHIVE_NAME).tar.gz" -C "$(PACKAGING_DIR)" "$(NERVES_ARCHIVE_NAME)"
	rm -rf "$(PACKAGING_DIR)"
