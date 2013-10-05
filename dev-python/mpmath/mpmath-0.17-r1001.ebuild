# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="py.test"

inherit distutils eutils

MY_PN="${PN}-all"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="https://github.com/fredrik-johansson/mpmath http://code.google.com/p/mpmath/ https://pypi.python.org/pypi/mpmath"
SRC_URI="http://mpmath.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples gmp matplotlib"

RDEPEND="gmp? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-python/gmpy) )
	matplotlib? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-python/matplotlib) )"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES"

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}/${P}-avoid_tests_installation.patch"
	epatch "${FILESDIR}/${P}-python-3.2.patch"
	epatch "${FILESDIR}/${P}-gmpy-2.patch"

	# mpmath/conftest.py is incompatible with current versions of dev-python/py.
	rm -f mpmath/conftest.py

	# Disable test, which requires X.
	rm -f mpmath/tests/test_visualization.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		python_execute PYTHONPATH="../build-$(PYTHON -f --ABI)/lib" "$(PYTHON -f)" build.py || die "Generation of documentation failed"
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	delete_version-specific_modules() {
		if [[ "$(python_get_version -l --major)" == "2" ]]; then
			rm -f "${ED}$(python_get_sitedir)/${PN}/libmp/exec_py3.py"
		else
			rm -f "${ED}$(python_get_sitedir)/${PN}/libmp/exec_py2.py"
		fi
	}
	python_execute_function -q delete_version-specific_modules

	if use doc; then
		dohtml -r doc/build/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins demo/*
	fi
}
