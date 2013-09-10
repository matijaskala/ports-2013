# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython *-pypy-*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Python to GNU Octave bridge"
HOMEPAGE="http://pypi.python.org/pypi/oct2py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples"

RDEPEND="$(python_abi_depend dev-python/numpy)
	$(python_abi_depend sci-libs/scipy)
	sci-mathematics/octave"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		PYTHONPATH="build-$(PYTHON -f --ABI)/lib" sphinx-build doc html || die "Generation of documentation failed"
	fi
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/oct2py/tests"
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r html/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r example/*
	fi
}
