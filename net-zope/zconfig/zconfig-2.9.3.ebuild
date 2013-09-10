# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="ZConfig"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Structured Configuration Library"
HOMEPAGE="http://pypi.python.org/pypi/ZConfig"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend net-zope/zope.testing) )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="NEWS.txt README.txt"
PYTHON_MODULES="${MY_PN}"

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/ZConfig/components/basic/tests"
		rm -fr "${ED}$(python_get_sitedir)/ZConfig/components/logger/tests"
		rm -fr "${ED}$(python_get_sitedir)/ZConfig/tests"
	}
	python_execute_function -q delete_tests
}
