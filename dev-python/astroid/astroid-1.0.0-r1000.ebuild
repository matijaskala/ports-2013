# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="rebuild a new abstract syntax tree from Python's ast"
HOMEPAGE="http://astroid.org/ https://bitbucket.org/logilab/astroid https://pypi.python.org/pypi/astroid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="test"

# Version specified in __pkginfo__.py.
RDEPEND="$(python_abi_depend ">=dev-python/logilab-common-0.60.0")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend -e "3.* *-jython *-pypy-*" dev-python/egenix-mx-base) )"

src_test() {
	testing() {
		local tpath="${T}/test-${PYTHON_ABI}"
		local spath="${tpath}$(python_get_sitedir)"

		python_execute "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --root="${tpath}" || die "Installation for tests failed with $(python_get_implementation_and_version)"

		# pytest uses tests placed relatively to the current directory.
		pushd "${spath}/astroid" > /dev/null || return
		python_execute PYTHONPATH="${spath}" pytest -v || return
		popd > /dev/null || return
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/astroid/test"
	}
	python_execute_function -q delete_tests
}
