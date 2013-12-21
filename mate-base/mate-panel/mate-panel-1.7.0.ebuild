# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
MATE_LA_PUNT="yes"
PYTHON_COMPAT=( python2_{6,7} )

inherit mate python-r1

DESCRIPTION="The MATE panel"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3 +introspection networkmanager"

RDEPEND="
	gtk3? ( x11-libs/gtk+:3[introspection?]
			x11-libs/libwnck:3[introspection?]
			>=media-libs/libcanberra-0.23[gtk3] )
	!gtk3? ( x11-libs/gtk+:2[introspection?]
			x11-libs/libwnck:1[introspection?]
			>=media-libs/libcanberra-0.23[gtk] )
	>=mate-base/mate-desktop-1.7.0[gtk3?]
	>=x11-libs/pango-1.15.4[introspection?]
	>=dev-libs/glib-2.25.12:2[${PYTHON_USEDEP}]
	>=dev-libs/libmateweather-1.7.0[gtk3?]
	dev-libs/libxml2:2
	>=mate-base/mate-menus-1.5.0[${PYTHON_USEDEP}]
	gnome-base/librsvg:2
	>=dev-libs/dbus-glib-0.80
	>=sys-apps/dbus-1.1.2
	>=x11-libs/cairo-1
	x11-libs/libXau
	>=x11-libs/libXrandr-1.2
	>=gnome-base/dconf-0.10.0
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	networkmanager? ( >=net-misc/networkmanager-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	app-text/yelp-tools
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	~app-text/docbook-xml-dtd-4.1.2
	>=mate-base/mate-common-1.7.0"

src_prepare() {
	sed -e '/toplevel-id-list \= \/apps\/panel\/general\/toplevel_id_list/d' \
		-i data/mate-panel.convert || die
	sed -e '/object-id-list \= \/apps\/panel\/general\/object_id_list/d' \
		-i data/mate-panel.convert || die
	mate_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	local myconf
	use gtk3 && myconf="${myconf} --with-gtk=3.0"
	use !gtk3 && myconf="${myconf} --with-gtk=2.0"

	mate_src_configure \
		--libexecdir=/usr/libexec/mate-applets \
		--disable-deprecation-flags \
		$(use_enable networkmanager network-manager) \
		$(use_enable introspection) \
		${myconf}
}
