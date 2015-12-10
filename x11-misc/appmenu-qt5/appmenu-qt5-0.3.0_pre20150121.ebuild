# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="Application menu module for Qt"
HOMEPAGE="https://launchpad.net/appmenu-qt"
MY_PV="${PV/_pre/+15.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-libs/libdbusmenu-qt"
RDEPEND="${DEPEND}"

DOCS=( NEWS README )

src_install() {
	qt5-build_src_install

	insinto /etc/profile.d
	doins data/appmenu-qt5.sh
}
