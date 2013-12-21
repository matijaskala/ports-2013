# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit mate

DESCRIPTION="The MATE Terminal"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="gtk3"

RDEPEND=">=dev-libs/glib-2.25.12:2
	gtk3? ( x11-libs/gtk+:3 x11-libs/vte:2.90 )
	!gtk3? ( x11-libs/gtk+:2 x11-libs/vte:0 )
	x11-libs/libSM
	>=gnome-base/dconf-0.10.0
	>=mate-base/mate-desktop-1.6.0"

DEPEND="${RDEPEND}
	|| ( dev-util/gtk-builder-convert <=x11-libs/gtk+-2.24.10:2 )
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	app-text/yelp-tools
	>=app-text/scrollkeeper-0.3.11"

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	local myconf
	use gtk3 && myconf="${myconf} --with-gtk=3.0"
	use !gtk3 && myconf="${myconf} --with-gtk=2.0"

	mate_src_configure ${myconf}
}
