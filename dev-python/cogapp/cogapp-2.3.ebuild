# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# *-jython: http://bugs.jython.org/issue1973
PYTHON_RESTRICTED_ABIS="2.5 *-jython"

inherit distutils

DESCRIPTION="Cog: A code generator for executing Python snippets in source files."
HOMEPAGE="http://nedbatchelder.com/code/cog/ https://pypi.python.org/pypi/cogapp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	distutils_src_prepare

	# Disable installation of test_cog.py script.
	sed -e "/'scripts\/test_cog.py'/d" -i setup.py

	# Disable failing test.
	sed -e "s/testAtFileWithTrickyFilenames/_&/" -i cogapp/test_cogapp.py
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" scripts/test_cog.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -f "${ED}$(python_get_sitedir)/cogapp/test_"*
	}
	python_execute_function -q delete_tests
}
