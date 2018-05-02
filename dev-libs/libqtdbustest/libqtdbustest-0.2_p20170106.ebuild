# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Library to facilitate testing DBus interactions in Qt applications"
HOMEPAGE="https://launchpad.net/libqtdbustest"
MY_PV="${PV/_p/+17.04.}"
GTEST_PV="1.8.0"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz
	https://github.com/google/googletest/archive/release-${GTEST_PV}.tar.gz -> gtest-${GTEST_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
S=${WORKDIR}
RESTRICT="mirror"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qttest:5"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DGMOCK_SOURCE_DIR="${WORKDIR}"/googletest-release-${GTEST_PV}/googlemock
		-DGMOCK_INCLUDE_DIRS="${WORKDIR}"/googletest-release-${GTEST_PV}/googlemock/include
		-DGTEST_INCLUDE_DIRS="${WORKDIR}"/googletest-release-${GTEST_PV}/googletest/include
	)

	cmake-utils_src_configure
}
