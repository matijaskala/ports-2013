# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
HOMEPAGE="http://www.xxhash.com/"
SRC_URI="https://github.com/Cyan4973/xxHash/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
RESTRICT="mirror"

S=${WORKDIR}/xxHash-${PV}/cmake_unofficial

mycmakeargs=( -DBUILD_SHARED_LIBS=ON )

src_prepare() {
	sed -i "s/lib$/$(get_libdir)/;/CMAKE_INSTALL_RPATH /d" CMakeLists.txt || die
	default
}
