# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit distutils

DESCRIPTION="Turn HTML into equivalent Markdown-structured text."
HOMEPAGE="http://www.aaronsw.com/2002/html2text/ https://github.com/aaronsw/html2text https://pypi.python.org/pypi/html2text"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/chardet)
	$(python_abi_depend dev-python/feedparser)
	$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}"

PYTHON_MODULES="html2text.py"

src_prepare() {
	distutils_src_prepare

	# Avoid file collision with app-text/html2text.
	sed -e "s/html2text=html2text:main/pyhtml2text=html2text:main/" -i setup.py
}
