# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="apipkg: namespace control and lazy-import mechanism"
HOMEPAGE="https://bitbucket.org/hpk42/apipkg http://pypi.python.org/pypi/apipkg"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip
	$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

DOCS="CHANGELOG README.txt"
PYTHON_MODULES="apipkg.py"

src_prepare() {
	distutils_src_prepare

	# Fix tests with Jython.
	# https://bitbucket.org/hpk42/apipkg/issue/2
	sed -e "s/type(sys)('hello')/types.ModuleType('hello')/" -i test_apipkg.py
}
