# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ettercap/ettercap-0.8.0.ebuild,v 1.2 2013/09/21 13:58:05 ago Exp $

EAPI=5

CMAKE_MIN_VERSION=2.8

inherit cmake-utils

DESCRIPTION="A suite for man in the middle attacks"
HOMEPAGE="https://github.com/Ettercap/ettercap"
SRC_URI="https://github.com/Ettercap/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz" #mirror does not work

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gtk ipv6 ncurses +plugins ssl"

RDEPEND="dev-libs/libpcre
	net-libs/libnet:1.1
	>=net-libs/libpcap-0.8.1
	sys-libs/zlib
	gtk? (
		>=dev-libs/atk-1.2.4
		>=dev-libs/glib-2.2.2:2
		media-libs/freetype
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-2.2.2:2
		>=x11-libs/pango-1.2.3
	)
	ncurses? ( >=sys-libs/ncurses-5.3 )
	plugins? (
		>=net-misc/curl-7.26.0
		sys-devel/libtool
	)
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	app-text/ghostscript-gpl
	sys-devel/flex
	virtual/yacc"

src_prepare() {
	sed -i "s:Release:Release Gentoo:" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable ncurses CURSES)
		$(cmake-utils_use_enable gtk)
		$(cmake-utils_use_enable ssl)
		$(cmake-utils_use_enable plugins)
		$(cmake-utils_use_enable ipv6)
		-DINSTALL_SYSCONFDIR="${EROOT}"etc
	)
	cmake-utils_src_configure
}
