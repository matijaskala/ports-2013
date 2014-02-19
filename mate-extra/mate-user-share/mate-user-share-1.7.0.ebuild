# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit mate multilib

DESCRIPTION="Personal file sharing for the Mate desktop"
HOMEPAGE="http://www.mate-desktop.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# FIXME: could libnotify be made optional ?
#        is consolekit needed or not ?
# FIXME: gnome-bluetooth is a hard-dep
# bluetooth is pure runtime dep (dbus)
RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.14:2
	>=app-mobilephone/obex-data-server-0.4
	>=dev-libs/dbus-glib-0.70
	dev-libs/libunique:1
	>=mate-base/caja-1.7.0
	media-libs/libcanberra[gtk]
	>=net-wireless/mate-bluetooth-1.5.0
	>=net-wireless/bluez-4.18
	>=sys-apps/dbus-1.1.1
	>=www-apache/mod_dnssd-0.6
	=www-servers/apache-2.2*[apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_authn_file,apache2_modules_auth_digest,apache2_modules_authz_groupfile]
	>=x11-libs/libnotify-0.7.0"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	app-text/docbook-xml-dtd:4.1.2"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	gnome2_src_configure \
		--with-httpd=apache2 \
		--with-modules-path=/usr/$(get_libdir)/apache2/modules/
}
