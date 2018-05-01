# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Google's C++ mocking framework"
HOMEPAGE="https://github.com/google/googlemock"
SRC_URI="${HOMEPAGE}/archive/release-${PV}.tar.gz -> googlemock-release-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

S=${WORKDIR}/googlemock-release-${PV}

src_install() {
	insinto /usr/src/gmock/include/gmock
	doins include/gmock/*.h

	insinto /usr/src/gmock/include/gmock/internal
	doins include/gmock/internal/*.h

	insinto /usr/src/gmock/src
	doins src/*.cc

	insinto /usr/src/gmock
	doins CMakeLists.txt
}
