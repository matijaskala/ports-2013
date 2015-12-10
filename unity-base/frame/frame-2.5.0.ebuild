# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

DESCRIPTION="uTouch Frame Library"
HOMEPAGE="https://launchpad.net/frame"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}daily13.06.05.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${P}daily13.06.05
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
