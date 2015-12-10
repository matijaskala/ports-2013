# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

SRC_SUFFIX="orig.tar.xz"
inherit autotools base eutils python-single-r1

DESCRIPTION="Event Emulation for the uTouch Stack"
HOMEPAGE="https://launchpad.net/evemu"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
