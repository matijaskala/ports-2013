# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_3,3_4,3_5} )

inherit cmake-utils eutils python-r1

DESCRIPTION="Error tolerant matching engine used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libcolumbus"
MY_PV=${PV/_p/+15.10.}
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"
REQUIRED_USE="test? ( debug )"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="dev-cpp/sparsehash
	dev-libs/boost:=[${PYTHON_USEDEP}]
	>=dev-libs/icu-52:=
	${PYTHON_DEPS}"

src_prepare() {
	# Let cmake find python (Gentoo does not install a custom python3.pc pkgconfig file like Ubuntu does) #
	epatch -p1 "${FILESDIR}/cmake_find-python.diff"
	sed -e 's:PYTHONLIBS_INCLUDE_DIRS:PYTHON_INCLUDE_DIRS:g' \
		-i python/CMakeLists.txt || die
	sed -e 's:COMMAND ${CMAKE_SOURCE_DIR}/cmake/pysoabi.py:COMMAND cmake/pysoabi.py:g' \
		-i cmake/python.cmake || die

	python_copy_sources
	preparation() {
		python_fix_shebang .
		cp -rfv python/pch/colpython_pch.hh "${BUILD_DIR}/python/colpython_pch.hh"
		cmake-utils_src_prepare
	}
	python_foreach_impl run_in_build_dir preparation
}

src_configure() {
	configuration() {
		mycmakeargs+=(-DPYTHONDIR="$(python_get_sitedir)")
		cmake-utils_src_configure
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		cmake-utils_src_compile
	}
	python_foreach_impl run_in_build_dir compilation
}

src_test() {
	testing() {
		cmake-utils_src_test
	}
	python_foreach_impl run_in_build_dir testing
}

src_install() {
	installation() {
		cmake-utils_src_install
	}
	python_foreach_impl run_in_build_dir installation
}
