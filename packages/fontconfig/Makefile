PACKAGE_NAME=fontconfig
PACKAGE_VERSION=2.13.92

PACKAGE_URL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-$(PACKAGE_VERSION).tar.gz
PACKAGE_FILE=fontconfig-$(PACKAGE_VERSION).tar.gz
PACKAGE_ARCHIVE_DIR=fontconfig-$(PACKAGE_VERSION)

CONFIGURE_PARAMS=--host=$(GNU_HOST_NAME) --prefix=$(ENGINE_PATH) --with-cache-dir=/var/cache/fontconfig --disable-docs

include $(BASEDIR)/package.mk
