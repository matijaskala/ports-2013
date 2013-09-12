# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils eutils

DESCRIPTION="World timezone definitions for Python"
HOMEPAGE="https://pypi.python.org/pypi/pytz http://pytz.sourceforge.net/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)
	sys-libs/timezone-data"
RDEPEND="${DEPEND}"

DOCS="CHANGES.txt"

src_prepare() {
	distutils_src_prepare

	# Use timezone-data zoneinfo.
	epatch "${FILESDIR}/${PN}-2009j-zoneinfo.patch"
}

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" pytz/tests/test_tzinfo.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_zoneinfo() {
		rm -fr "${ED}$(python_get_sitedir)/pytz/zoneinfo"
	}
	python_execute_function -q delete_zoneinfo
}
