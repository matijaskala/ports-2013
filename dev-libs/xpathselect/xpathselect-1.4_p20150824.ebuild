# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GTESTVER="1.7.0"

inherit cmake-utils

DESCRIPTION="Select objects in an object tree using XPath queries"
HOMEPAGE="https://launchpad.net/xpathselect"
MY_PV="${PV/_p/+15.10.}.1"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz
	test? ( https://github.com/google/googletest/archive/release-${GTESTVER}.tar.gz -> gtest-${GTESTVER}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="test? ( dev-cpp/gtest )
	dev-libs/boost"

src_prepare() {
	! use test && \
		sed -e '/add_subdirectory(test)/d' \
			-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	use test && \
		mycmakeargs+=(-DGTEST_ROOT_DIR="${WORKDIR}/gtest-${GTESTVER}"
				-DGTEST_SRC_DIR="${WORKDIR}/gtest-${GTESTVER}/src/")
	cmake-utils_src_configure
}
