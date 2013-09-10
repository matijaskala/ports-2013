# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="2.5"

inherit distutils

DESCRIPTION="Better living through Python with decorators"
HOMEPAGE="http://pypi.python.org/pypi/decorator http://code.google.com/p/micheles/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

DOCS="README.txt"
PYTHON_MODULES="decorator.py"

src_test() {
	testing() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" documentation3.py
		else
			python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" documentation.py
		fi
	}
	python_execute_function testing
}
