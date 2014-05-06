# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/cinnamon-session/cinnamon-session-2.2.0.ebuild,v 1.1 2014/05/06 03:09:08 tetromino Exp $

EAPI="5"

inherit autotools eutils gnome2

DESCRIPTION="Cinnamon session manager"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-session/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gconf ipv6 systemd"

RDEPEND="
	>=dev-libs/dbus-glib-0.76
	>=dev-libs/glib-2.32:2
	>=dev-libs/json-glib-0.10
	media-libs/libcanberra
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.90.7:3
	x11-libs/cairo
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	virtual/opengl
	gconf? ( gnome-base/gconf:2 )
	systemd? ( >=sys-apps/systemd-183 )
	!systemd? (
		>=sys-power/upower-0.9
		<sys-power/upower-0.99 )
"
RDEPEND="${COMMON_DEPEND}
	!systemd? ( sys-auth/consolekit )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	doc? ( app-text/xmlto )
"

src_prepare() {
	# make upower check non-automagic
	epatch "${FILESDIR}/${PN}-2.2.0-automagic-upower.patch"
	epatch_user

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS README README.md"

	gnome2_src_configure \
		--disable-deprecation-flags \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--disable-static \
		$(use_enable doc docbook-docs) \
		$(use_enable gconf) \
		$(use_enable ipv6) \
		$(use_enable systemd) \
		$(usex systemd --disable-old-upower --enable-old-upower)
}
