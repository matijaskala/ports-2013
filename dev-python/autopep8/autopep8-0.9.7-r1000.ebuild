# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# http://bugs.jython.org/issue1982
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"

inherit distutils

DESCRIPTION="A tool that automatically formats Python code to conform to the PEP 8 style guide"
HOMEPAGE="https://github.com/hhatto/autopep8 https://pypi.python.org/pypi/autopep8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend ">=dev-python/pep8-1.4.6")
	$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"

PYTHON_MODULES="${PN}.py"

src_test() {
	testing() {
		if [[ "$(python_get_implementation)" == "Jython" ]]; then
			# http://bugs.jython.org/issue1944
			python_execute LC_ALL="en_US.UTF-8" PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_${PN}.py
		else
			python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_${PN}.py
		fi
	}
	python_execute_function testing
}
