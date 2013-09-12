# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"

inherit distutils

DESCRIPTION="Serialization based on ast.literal_eval"
HOMEPAGE="https://github.com/irmen/Serpent https://pypi.python.org/pypi/serpent"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODULES="serpent.py"
