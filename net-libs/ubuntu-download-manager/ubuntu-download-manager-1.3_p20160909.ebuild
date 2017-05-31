# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A daemon that offers a DBus API to perform downloads"
HOMEPAGE="https://launchpad.net/ubuntu-download-manager"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+16.10.}.1.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
S=${WORKDIR}
RESTRICT="mirror"

COMMON_DEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	sys-apps/dbus
	dev-qt/qtsystems:5"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	dev-cpp/glog
	sys-libs/libnih[dbus]"

src_prepare() {
	export QT_SELECT=5

	use test || \
		sed -e '/add_subdirectory(tests)/d' \
			-i CMakeLists.txt
	use doc || \
		sed -e '/add_subdirectory(docs)/d' \
			-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_LIBEXECDIR=/usr/lib)
	cmake-utils_src_configure
}
