# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomekbd/libgnomekbd-3.6.0.ebuild,v 1.3 2013/12/08 18:38:02 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+introspection test"

RDEPEND="
	>=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.91.7:3[introspection?]
	>=x11-libs/libxklavier-5.2[introspection?]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_configure() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)
		$(use_enable test tests)"
	gnome2_src_configure
}
