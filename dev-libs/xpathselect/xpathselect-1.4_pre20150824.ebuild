# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GTESTVER="1.6.0"

inherit cmake-utils

DESCRIPTION="Select objects in an object tree using XPath queries"
HOMEPAGE="https://launchpad.net/xpathselect"
MY_PV="${PV/_pre/+15.10.}.1"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz
	test? ( http://googletest.googlecode.com/files/gtest-${GTESTVER}.zip )"

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
}

src_configure() {
	use test && \
		local mycmakeargs="${mycmakeargs}
				-DGTEST_ROOT_DIR="${WORKDIR}/gtest-${GTESTVER}"
				-DGTEST_SRC_DIR="${WORKDIR}/gtest-${GTESTVER}/src/"
				"
	cmake-utils_src_configure
}
