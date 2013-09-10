# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"

inherit distutils

MY_PN="SPARQLWrapper"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SPARQL Endpoint interface to Python"
HOMEPAGE="http://sparql-wrapper.sourceforge.net/ https://pypi.python.org/pypi/SPARQLWrapper"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="W3C"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/rdflib)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS.txt ChangeLog.txt"
PYTHON_MODULES="${MY_PN}"
