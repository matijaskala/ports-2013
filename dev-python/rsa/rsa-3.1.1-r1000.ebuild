# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Pure-Python RSA implementation"
HOMEPAGE="http://stuvel.eu/rsa http://pypi.python.org/pypi/rsa"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="$(python_abi_depend ">=dev-python/pyasn1-0.1.3")
	$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"
