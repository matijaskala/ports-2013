# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit mate eutils

DESCRIPTION="A calculator application for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3"

RDEPEND="!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	>=dev-libs/glib-2.30:2
	dev-libs/libxml2:2"

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
	>=app-text/mate-doc-utils-1.2.1"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	use gtk3 && G2CONF="${G2CONF} --with-gtk=3.0"
	use !gtk3 && G2CONF="${G2CONF} --with-gtk=2.0"

	gnome2_src_configure
}
