# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

UVER_PREFIX="daily13.06.05"
inherit autotools eutils ubuntu-versionator

DESCRIPTION="uTouch Frame Library"
HOMEPAGE="https://launchpad.net/frame"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=sys-devel/gcc-4.6
	sys-libs/mtdev
	unity-base/evemu
	x11-base/xorg-server[dmx]
	>=x11-libs/libXi-1.5.99.1"

RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
