# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython *-pypy-*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit autotools eutils python

MY_PN="PythonMagick"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for ImageMagick"
HOMEPAGE="http://www.imagemagick.org/script/api.php"
SRC_URI="http://www.imagemagick.org/download/python/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend dev-libs/boost:0=[python])
	>=media-gfx/imagemagick-6.4:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PYTHON_CXXFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.1-use_active_python_version.patch"
	epatch "${FILESDIR}/${PN}-0.9.2-fix_detection_of_python_includedir.patch"

	eautoreconf
	python_clean_py-compile_files
	python_src_prepare
}

src_configure() {
	configuration() {
		sed -e "s/-lboost_python/-lboost_python-${PYTHON_ABI}/" -i Makefile.in
		econf \
			--disable-static \
			--with-boost-python="boost_python-${PYTHON_ABI}"
	}
	python_execute_function -s configuration
}

src_install() {
	python_src_install
	python_clean_installation_image
}

pkg_postinst() {
	python_mod_optimize PythonMagick
}

pkg_postrm() {
	python_mod_cleanup PythonMagick
}
