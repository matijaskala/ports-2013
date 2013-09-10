# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

DESCRIPTION="A wrapper for the Gnu Privacy Guard (GPG or GnuPG)"
HOMEPAGE="http://code.google.com/p/python-gnupg/ https://pypi.python.org/pypi/python-gnupg"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="app-crypt/gnupg"
RDEPEND="${DEPEND}"

PYTHON_MODULES="gnupg.py"

src_prepare() {
	distutils_src_prepare
	rm -f README
}
