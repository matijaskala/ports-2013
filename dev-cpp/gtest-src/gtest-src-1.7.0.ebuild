# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"
SRC_URI="${HOMEPAGE}/archive/release-${PV}.tar.gz -> googletest-release-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

S=${WORKDIR}/googletest-release-${PV}

src_install() {
	insinto /usr/src/gtest/include/gtest
	doins include/gtest/*.h

	insinto /usr/src/gtest/include/gtest/internal
	doins include/gtest/internal/*.h

	insinto /usr/src/gtest
	doins -r cmake src CMakeLists.txt
}
