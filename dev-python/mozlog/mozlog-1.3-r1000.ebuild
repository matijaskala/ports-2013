# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"

inherit distutils

DESCRIPTION="Robust log handling specialized for logging in the Mozilla universe"
HOMEPAGE="https://pypi.python.org/pypi/mozlog"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend virtual/python-json)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"
