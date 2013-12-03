# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cclive/cclive-0.9.3-r1.ebuild,v 1.1 2013/11/27 08:44:40 radhermit Exp $

EAPI=5

DESCRIPTION="Command line tool for extracting videos from various websites"
HOMEPAGE="http://cclive.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV:0:3}/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND=">=media-libs/libquvi-0.4.0
	>=dev-cpp/glibmm-2.24:2
	>=dev-libs/boost-1.49
	>=dev-libs/glib-2.24:2
	>=net-misc/curl-7.20
	>=dev-libs/libpcre-8.02[cxx]"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_configure() {
	econf --disable-ccl
}
