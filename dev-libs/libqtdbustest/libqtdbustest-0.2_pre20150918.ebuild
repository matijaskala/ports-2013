# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit cmake-utils

DESCRIPTION="Library to facilitate testing DBus interactions in Qt applications"
HOMEPAGE="https://launchpad.net/libqtdbustest"
MY_PV="${PV/_pre/+15.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="dev-cpp/gmock
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qttest:5"
