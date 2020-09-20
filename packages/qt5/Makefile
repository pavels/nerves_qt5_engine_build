PACKAGE_NAME=qt5
PACKAGE_VERSION=5.15

PACKAGE_URL=https://download.qt.io/archive/qt/$(PACKAGE_VERSION)/$(PACKAGE_VERSION).0/single/qt-everywhere-src-$(PACKAGE_VERSION).0.tar.xz
PACKAGE_FILE=qt-everywhere-src-$(PACKAGE_VERSION).0.tar.xz
PACKAGE_ARCHIVE_DIR=qt-everywhere-src-$(PACKAGE_VERSION).0

CUSTOM_BUILD=1

CONFIGURE_PARAMS=-release \
                 -opengl es2 \
                 -device $(QT5_DEVICE) \
                 -device-option CROSS_COMPILE=$(TOOLCHAIN_ROOT)/bin/$(GNU_HOST_NAME)- \
                 -sysroot ${SYSROOT} \
                 -opensource \
                 -confirm-license \
                 -skip qtwayland \
                 -skip qtscript \
                 -skip qtandroidextras \
                 -skip qtcanvas3d \
                 -skip qtgamepad \
                 -skip qtmacextras \
                 -skip qtpurchasing \
                 -skip qtquickcontrols \
                 -skip qtwinextras \
                 -skip qtx11extras \
                 -skip qtserialport \
                 -no-sql-sqlite \
                 -make libs \
                 -extprefix $(SYSROOT)$(ENGINE_PATH)/qt5 \
                 -hostprefix $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/host-tools \
                 -no-use-gold-linker \
                 -no-gbm \
                 -nomake examples \
                 -nomake tests \
                 -webengine-jumbo-build 0 \
                 QMAKE_CFLAGS_ISYSTEM= \
                 QMAKE_RPATHLINKDIR=$(SYSROOT)$(ENGINE_PATH)/lib

include $(BASEDIR)/package.mk

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.patched: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.unpacked
  # Too long filenames in qtwebengine build - https://bugreports.qt.io/browse/QTBUG-59769
	patch -p1 -d $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/$(PACKAGE_ARCHIVE_DIR) < 0001-long_filenames_patch.patch
	patch -p1 -d $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/$(PACKAGE_ARCHIVE_DIR) < 0002-gcc-10.patch
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.patched

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.built: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.patched
	mkdir -p $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/build
	# Symlinked fontconfig - https://bugreports.qt.io/browse/QTBUG-61158
	cd $(SYSROOT)/usr/include && rm -f fontconfig && ln -s ../..$(ENGINE_PATH)/include/fontconfig fontconfig
	cd $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/build && ../$(PACKAGE_ARCHIVE_DIR)/configure $(CONFIGURE_PARAMS)
	$(MAKE) -C $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/build -j4
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.built

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.built
	$(MAKE) -C $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/build -j4 install
	find $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/host-tools/mkspecs -name "*.pri" -exec sed -i "s~$(SYSROOT)$(ENGINE_PATH)~\$$\$$(QT5_ENGINE_DIR)~g" {} \;
	find $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/host-tools/mkspecs -name "*.pri" -exec sed -i "s~$(SYSROOT)~\$$\$$(NERVES_SYSROOT_DIR)~g" {} \;
	find $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/host-tools/mkspecs -name "*.pri" -exec sed -i "s~$(TOOLCHAIN_ROOT)~\$$\$$(NERVES_TOOLCHAIN_DIR)~g" {} \;
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed
