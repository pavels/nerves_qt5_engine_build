PACKAGE_NAME=dbus
PACKAGE_VERSION=1.12.20

PACKAGE_URL=https://dbus.freedesktop.org/releases/dbus/dbus-$(PACKAGE_VERSION).tar.gz
PACKAGE_FILE=dbus-$(PACKAGE_VERSION).tar.gz
PACKAGE_ARCHIVE_DIR=dbus-$(PACKAGE_VERSION)

CONFIGURE_PARAMS=--host=$(GNU_HOST_NAME) \
								 --prefix=$(ENGINE_PATH) \
								 --with-dbus-user=dbus \
								 --disable-tests \
								 --disable-asserts \
								 --enable-abstract-sockets \
								 --disable-selinux \
								 --disable-xml-docs \
								 --disable-doxygen-docs \
								 --disable-static \
								 --disable-dnotify \
								 --localstatedir=/var \
								 --with-system-socket=/var/run/dbus/system_bus_socket \
								 --with-system-pid-file=/var/run/messagebus.pid \
								 --without-x								 

include $(BASEDIR)/package.mk
