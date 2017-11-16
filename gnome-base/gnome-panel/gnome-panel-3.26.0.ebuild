# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools gnome2

DESCRIPTION="The GNOME panel"
HOMEPAGE="https://git.gnome.org/browse/gnome-panel"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
IUSE="eds"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
RESTRICT="mirror"

RDEPEND="
	>=dev-libs/glib-2.46.0:2
	>=dev-libs/libgweather-3.20:2=
	dev-libs/libxml2:2
	gnome-base/dconf
	gnome-base/gconf:2
	gnome-base/gdm
	>=gnome-base/gnome-desktop-3.20:3=
	>=gnome-base/gnome-menus-3.13:3
	gnome-base/gsettings-desktop-schemas
	gnome-base/librsvg:2
	net-libs/telepathy-glib
	sys-auth/polkit
	x11-libs/cairo[X,glib]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libXau
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXrandr
	x11-libs/libwnck:3
	>=x11-libs/pango-1.40

	eds? ( >=gnome-extra/evolution-data-server-3.20:= )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	>=dev-lang/perl-5
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig"
# eautoreconf needs
#	dev-libs/gobject-introspection-common
#	gnome-base/gnome-common

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# XXX: Make presence/telepathy-glib support optional?
	#      We can do that if we intend to support fallback-only as a setup
	gnome2_src_configure \
		--disable-static \
		$(use_enable eds)
}
