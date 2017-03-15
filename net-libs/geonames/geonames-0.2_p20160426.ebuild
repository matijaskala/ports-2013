# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Parse and query the geonames database dump"
HOMEPAGE="https://launchpad.net/geonames"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+16.04.}-0ubuntu1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${PN}
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	dev-util/gtk-doc"

src_prepare() {
	default
	eautoreconf
}
