# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-ui"
MY_PV="${PV/_pre/+15.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/${PN}-${MY_PV}"
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	net-libs/libproxy[-kde]
	unity-base/signon[qt5]
	x11-libs/libaccounts-qt:=[qt5]
	x11-libs/libnotify"

QT5_BUILD_DIR="${S}"
