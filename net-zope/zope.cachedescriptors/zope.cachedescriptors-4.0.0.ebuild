# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Method and property caching decorators"
HOMEPAGE="http://pypi.python.org/pypi/zope.cachedescriptors"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN/.//}"
