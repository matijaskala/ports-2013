# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1

DESCRIPTION="Event Emulation for the uTouch Stack"
HOMEPAGE="https://launchpad.net/evemu"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-static=no \
		$(use_enable test tests)
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
