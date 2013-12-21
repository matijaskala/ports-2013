# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"

inherit mate

DESCRIPTION="The MATE Desktop configuration tool"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# TODO: appindicator
# libgnomekbd-2.91 breaks API/ABI
RDEPEND="x11-libs/libXft
	>=x11-libs/libXi-1.2
	x11-libs/gtk+:2
	>=dev-libs/glib-2.28:2
	>=gnome-base/librsvg-2.0:2
	>=mate-base/mate-file-manager-1.2.2
	>=media-libs/fontconfig-1
	>=dev-libs/dbus-glib-0.73
	>=x11-libs/libxklavier-4.0
	>=x11-wm/mate-window-manager-1.5.0
	>=mate-base/libmatekbd-1.2.0
	>=mate-base/mate-desktop-1.5.2
	>=mate-base/mate-menus-1.2.0
	>=mate-base/mate-settings-daemon-1.5.2
	>=gnome-base/dconf-0.10.0

	dev-libs/libunique:1
	x11-libs/pango
	dev-libs/libxml2
	media-libs/freetype
	media-libs/libcanberra[gtk]

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
	>=app-text/mate-doc-utils-1.2.1
	>=mate-base/mate-common-1.2.2"

src_prepare() {
	epatch "${FILESDIR}/${P}-collision-fix.patch"
	epatch "${FILESDIR}/${PN}-1.6-libsecret.patch"
	#Make tests run
	epatch "${FILESDIR}/${PN}-1.6.1-fix-POTFILES.patch"
	eautoreconf
	mate_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"

	mate_src_configure \
		--disable-update-mimedb \
		--disable-appindicator
}
