# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

DESCRIPTION="Python style guide checker"
HOMEPAGE="https://github.com/jcrocholl/pep8 https://pypi.python.org/pypi/pep8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"

DOCS="CHANGES.txt"
PYTHON_MODULES="${PN}.py"

src_test() {
	testing() {
		python_execute "$(PYTHON)" pep8.py --doctest -v || return
		python_execute "$(PYTHON)" pep8.py --testsuite=testsuite -v || return
	}
	python_execute_function testing
}
