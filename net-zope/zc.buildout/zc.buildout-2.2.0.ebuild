# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"

inherit distutils

DESCRIPTION="System for managing development buildouts"
HOMEPAGE="http://www.buildout.org/ https://github.com/buildout/buildout https://pypi.python.org/pypi/zc.buildout"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zc[zc])
	$(python_abi_depend ">=dev-python/setuptools-0.7")"
DEPEND="${RDEPEND}"

DOCS="CHANGES.rst README.rst"
PYTHON_MODULES="${PN/.//}"
