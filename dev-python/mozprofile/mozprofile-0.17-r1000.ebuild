# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[sqlite]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Library to create and modify Mozilla application profiles"
HOMEPAGE="https://pypi.python.org/pypi/mozprofile"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/manifestdestiny)
	$(python_abi_depend ">=dev-python/mozfile-0.12")
	$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"
