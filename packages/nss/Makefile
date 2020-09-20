PACKAGE_NAME=nss
PACKAGE_VERSION=3.55

PACKAGE_URL=https://archive.mozilla.org/pub/security/nss/releases/NSS_3_55_RTM/src/nss-$(PACKAGE_VERSION).tar.gz
PACKAGE_FILE=nss-$(PACKAGE_VERSION).tar.gz
PACKAGE_ARCHIVE_DIR=nss-$(PACKAGE_VERSION)/nss

CUSTOM_BUILD=1

ESCAPED_ENGINE_PATH=$(shell printf '%s\n' "$(ENGINE_PATH)" | sed -e 's/[\/&]/\\&/g' )

export NSPR_INCLUDE_DIR=$(SYSROOT)$(ENGINE_PATH)/include/nspr
export NSPR_LIB_DIR=$(SYSROOT)$(ENGINE_PATH)/lib
export NS_USE_GCC=1
export NSS_DISABLE_GTESTS=1
export CROSS_CC=$(GNU_HOST_NAME)-gcc -I$(SYSROOT)$(ENGINE_PATH)/include
export CROSS_CCC=$(GNU_HOST_NAME)-g++ -I$(SYSROOT)$(ENGINE_PATH)/include
export RANLIB=$(GNU_HOST_NAME)-ranlib
export OS_ARCH=Linux
export OS_RELEASE=0
export NSS_ENABLE_WERROR=0
export MOZILLA_CLIENT=1
export NSS_USE_SYSTEM_SQLITE=1
export OS_TEST=arm
export CHECKLOC=
export BUILD_TREE=$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/build

include $(BASEDIR)/package.mk

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.patched: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.unpacked
	patch -p1 -d $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/$(PACKAGE_ARCHIVE_DIR) < 0001-libnss-crosscompile.patch
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.patched

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.built: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.patched
	mkdir -p $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/build
	$(MAKE) -C $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/$(PACKAGE_ARCHIVE_DIR) coreconf
	$(MAKE) -C $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/$(PACKAGE_ARCHIVE_DIR) all
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.built

$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed: $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.built
	$(eval SRCDIR=$(shell ls -d $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/build/dist/Linux*))
	install -m 755 -t $(SYSROOT)$(ENGINE_PATH)/lib/ \
		$(SRCDIR)/lib/*.so
	install -m 755 -t $(SYSROOT)$(ENGINE_PATH)/lib/ \
		$(SRCDIR)/lib/*.a
	install -m 755 -d $(SYSROOT)$(ENGINE_PATH)/include/nss
	install -m 644 -t $(SYSROOT)$(ENGINE_PATH)/include/nss \
		$(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/build/dist/public/nss/*
	install -D -m 0644 nss.pc.in \
		$(SYSROOT)$(ENGINE_PATH)/lib/pkgconfig/nss.pc
	sed -i "s/@PREFIX@/${ESCAPED_ENGINE_PATH}/g;" \
		$(SYSROOT)$(ENGINE_PATH)/lib/pkgconfig/nss.pc
	sed -i "s/@VERSION@/${PACKAGE_VERSION}/g;" \
		$(SYSROOT)$(ENGINE_PATH)/lib/pkgconfig/nss.pc
	touch $(NERVES_BUILD_DIR)/$(PACKAGE_NAME)/.installed