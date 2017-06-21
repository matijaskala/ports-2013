# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-ui"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.04.}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
S=${WORKDIR}
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	net-libs/accounts-qt:=
	net-libs/libproxy[-kde]
	unity-base/signon
	x11-libs/libnotify
	test? ( dev-qt/qttest:5 )"

src_prepare() {
	default
	use test || \
		sed -e '/tests/d' \
			-i signon-ui.pro
}

src_configure() {
	eqmake5 PREFIX="${ED}"/usr
}
