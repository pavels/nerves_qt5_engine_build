ENGINE_PATH = /root/qt5-engine
PACKAGES = prepare toolchain sysroot sqlite nspr nss expat dbus freetype fontconfig libjpeg eudev fonts udev-rules qt5

ifndef NERVES_BUILD_CONFIG
$(error NERVES_BUILD_CONFIG is not set)
endif

include $(NERVES_BUILD_CONFIG)

ifndef MIX_TARGET
$(error MIX_TARGET is not set)
endif

ifndef NERVES_BUILD_DIR
$(error NERVES_BUILD_DIR is not set)
endif

ifndef GNU_HOST_NAME
$(error GNU_HOST_NAME is not set)
endif

ifndef QT5_DEVICE
$(error QT5_DEVICE is not set)
endif

ifndef NERVES_SYSTEM_IMAGE_URL
$(error NERVES_SYSTEM_IMAGE_URL is not set)
endif

ifndef NERVES_SYSTEM_IMAGE_DIR
$(error NERVES_SYSTEM_IMAGE_DIR is not set)
endif

ifndef NERVES_TOOLCHAIN_URL
$(error NERVES_TOOLCHAIN_URL is not set)
endif

ifndef NERVES_TOOLCHAIN_DIR
$(error NERVES_TOOLCHAIN_URL is not set)
endif

export

BASEDIR = $(shell pwd)

TOOLCHAIN_ROOT=$(NERVES_BUILD_DIR)/$(NERVES_TOOLCHAIN_DIR)
IMAGE_ROOT=$(NERVES_BUILD_DIR)/$(NERVES_SYSTEM_IMAGE_DIR)
SYSROOT=$(IMAGE_ROOT)/staging

PKG_CONFIG_PATH=
PKG_CONFIG_LIBDIR=$(SYSROOT)/usr/lib/pkgconfig:$(SYSROOT)/usr/share/pkgconfig:$(SYSROOT)$(ENGINE_PATH)/lib/pkgconfig:$(SYSROOT)$(ENGINE_PATH)/share/pkgconfig
PKG_CONFIG_SYSROOT_DIR=$(SYSROOT)

PATH+=:$(TOOLCHAIN_ROOT)/bin

.PHONY: system artifact $(PACKAGES)

$(PACKAGES):
	$(MAKE) -C "packages/$@" all

artifact: $(PACKAGES)

archive: artifact
	$(MAKE) -f "archive.mk" archive

