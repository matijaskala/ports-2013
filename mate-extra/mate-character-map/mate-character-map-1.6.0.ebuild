# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gucharmap/Attic/gucharmap-2.32.1.ebuild,v 1.10 2012/11/16 07:34:04 pacho dead $

EAPI="5"
MATE_LA_PUNT="yes"
GCONF_DEBUG="yes"
PYTHON_DEPEND="python? 2:2.5"

inherit mate python

DESCRIPTION="Unicode character map viewer"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cjk gtk3 +introspection python test"

RDEPEND=">=dev-libs/glib-2.16.3
	>=x11-libs/pango-1.2.1
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	introspection? ( >=dev-libs/gobject-introspection-0.6 )
	python? ( >=dev-python/pygtk-2.7.1 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	>=app-text/mate-doc-utils-1.2.1
	test? ( ~app-text/docbook-xml-dtd-4.1.2 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_enable cjk unihan)
		$(use_enable python python-bindings)"
	DOCS="ChangeLog NEWS README TODO"
	python_set_active_version 2
}
