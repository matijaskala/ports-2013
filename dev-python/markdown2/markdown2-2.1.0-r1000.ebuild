# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

DESCRIPTION="A fast and complete Python implementation of Markdown"
HOMEPAGE="https://github.com/trentm/python-markdown2 http://pypi.python.org/pypi/markdown2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/pygments)"
DEPEND="${RDEPEND}
	app-arch/unzip"

DOCS="CHANGES.md CONTRIBUTORS.txt"
PYTHON_MODULES="${PN}.py"

src_prepare() {
	distutils_src_prepare

	# Disable failing test.
	rm -f test/tm-cases/issue52_hang.*
}

src_test() {
	cd test

	testing() {
		python_execute PYTHONPATH="../build-${PYTHON_ABI}/lib" "$(PYTHON)" test.py
	}
	python_execute_function testing
}
