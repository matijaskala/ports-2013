# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit mate

DESCRIPTION="The MATE System Monitor"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3"

RDEPEND=">=dev-libs/glib-2.20:2
	!gtk3? ( x11-libs/gtk+:2
			>=dev-cpp/gtkmm-2.8:2.4
			x11-libs/libwnck:1 )
	gtk3? ( x11-libs/gtk+:3
			x11-libs/libwnck:3
			dev-cpp/gtkmm:3.0 )
	>=gnome-base/libgtop-2.23.1:2
	>=x11-themes/mate-icon-theme-1.6.0
	>=dev-cpp/glibmm-2.16:2
	dev-libs/libxml2:2
	>=gnome-base/librsvg-2.12:2
	>=dev-libs/dbus-glib-0.70"

DEPEND="${RDEPEND}
	>=app-text/mate-doc-utils-1.6.0
	virtual/pkgconfig
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	use gtk3 && G2CONF="${G2CONF} --with-gtk=3.0"
	use !gtk3 && G2CONF="${G2CONF} --with-gtk=2.0"

	gnome2_src_configure
}
