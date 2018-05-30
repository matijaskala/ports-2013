# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Qt binding and QML plugin for Dee for the Unity desktop"
HOMEPAGE="https://unity.ubuntu.com/"
MY_PV="${PV/_p/+14.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="mirror"

RDEPEND=">=dev-libs/dee-1.2.7
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	# Correct library installation path #
	sed \
		-e 's:LIBRARY DESTINATION lib/\${CMAKE_LIBRARY_ARCHITECTURE}:LIBRARY DESTINATION lib\${CMAKE_LIBRARY_ARCHITECTURE}:' \
		-e '/pkgconfig/{s/\/\${CMAKE_LIBRARY_ARCHITECTURE}/\${CMAKE_LIBRARY_ARCHITECTURE}\${LIB_SUFFIX}/}' \
		-i CMakeLists.txt
	sed \
		-e 's:lib/@CMAKE_LIBRARY_ARCHITECTURE@:lib@CMAKE_LIBRARY_ARCHITECTURE@@LIB_SUFFIX@:' \
		-i libdee-qt.pc.in

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs+=( -DWITHQT5=1 )

	cmake-utils_src_configure
}
