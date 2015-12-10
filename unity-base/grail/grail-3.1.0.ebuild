# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

DESCRIPTION="An implementation of the GRAIL (Gesture Recognition And Instantiation Library) interface"
HOMEPAGE="https://launchpad.net/grail"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}daily13.06.05.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}/${P}daily13.06.05
RESTRICT="mirror"

DEPEND=">=sys-devel/gcc-4.6
	sys-libs/mtdev
	unity-base/evemu
	unity-base/frame
	>=x11-libs/libXi-1.5.99.1"

RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
