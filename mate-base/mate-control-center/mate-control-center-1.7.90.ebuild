# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit mate

DESCRIPTION="The MATE Desktop configuration tool"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3"

# TODO: appindicator
# libgnomekbd-2.91 breaks API/ABI
RDEPEND="x11-libs/libXft
	>=x11-libs/libXi-1.2
	gtk3? ( x11-libs/gtk+:3
			media-libs/libcanberra[gtk3] )
	!gtk3? ( x11-libs/gtk+:2
			media-libs/libcanberra[gtk] )
	>=dev-libs/glib-2.28:2
	>=gnome-base/librsvg-2.0:2
	>=mate-base/caja-1.7.0
	>=media-libs/fontconfig-1
	>=dev-libs/dbus-glib-0.73
	>=x11-libs/libxklavier-4.0
	>=x11-wm/marco-1.7.0
	>=mate-base/libmatekbd-1.7.0[gtk3?]
	>=mate-base/mate-desktop-1.7.0[gtk3?]
	>=mate-base/mate-menus-1.2.0
	>=mate-base/mate-settings-daemon-1.7.0[gtk3?]
	>=gnome-base/dconf-0.10.0

	dev-libs/libunique:1
	x11-libs/pango
	dev-libs/libxml2
	media-libs/freetype

	x11-apps/xmodmap
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXxf86misc
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXcursor"

DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto
	x11-proto/randrproto
	x11-proto/renderproto

	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	dev-util/desktop-file-utils

	app-text/scrollkeeper
	>=mate-base/mate-common-1.7.0"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"

	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-appindicator
}
