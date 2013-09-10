# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# 3.[3-9]: https://github.com/dabeaz/ply/issues/34
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.[3-9] *-jython"

inherit distutils

DESCRIPTION="Python Lex-Yacc library"
HOMEPAGE="http://www.dabeaz.com/ply/ https://github.com/dabeaz/ply https://pypi.python.org/pypi/ply"
SRC_URI="http://www.dabeaz.com/ply/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="examples"

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

DOCS="ANNOUNCE CHANGES README TODO"

src_test() {
	python_enable_pyc

	cd test

	testing() {
		local exit_status="0" test
		for test in testlex.py testyacc.py; do
			if ! python_execute "$(PYTHON)" "${test}"; then
				eerror "${test} failed with $(python_get_implementation_and_version)"
				exit_status="1"
			fi
		done

		return "${exit_status}"
	}
	python_execute_function testing

	python_disable_pyc
}

src_install() {
	distutils_src_install

	dohtml -r doc/

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r example/*
	fi
}
