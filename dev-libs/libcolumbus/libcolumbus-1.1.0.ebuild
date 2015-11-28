# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

UVER_PREFIX="+14.04.20140325.3"

inherit cmake-utils eutils python-r1 ubuntu-versionator

DESCRIPTION="Error tolerant matching engine used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libcolumbus"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"
REQUIRED_USE="test? ( debug )"
RESTRICT="mirror"

DEPEND="dev-cpp/sparsehash
	dev-libs/boost[${PYTHON_USEDEP}]
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
		mycmakeargs="${mycmakeargs}
			-DPYTHONDIR="$(python_get_sitedir)"
			"
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
