# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}tk?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Python code static checker"
HOMEPAGE="http://pylint.org/ https://bitbucket.org/logilab/pylint https://pypi.python.org/pypi/pylint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="examples tk"

# Versions specified in __pkginfo__.py.
RDEPEND="$(python_abi_depend dev-python/astroid)
	$(python_abi_depend ">=dev-python/logilab-common-0.53.0")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
DOCS="doc/*.rst"

src_test() {
	testing() {
		python_execute PYTHONPATH="build/lib" pytest -v
	}
	python_execute_function -s testing
}

src_install() {
	distutils_src_install
	doman man/{pylint,pyreverse}.1

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/pylint/test"
	}
	python_execute_function -q delete_tests

	if use examples; then
		docinto examples
		dodoc examples/*
	fi

	if ! use tk; then
		rm -f "${ED}usr/bin/pylint-gui"*
	fi
}
