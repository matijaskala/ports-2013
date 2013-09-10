# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython *-pypy-*"

inherit distutils

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for GMP, MPC and MPFR libraries"
HOMEPAGE="http://code.google.com/p/gmpy/ https://pypi.python.org/pypi/gmpy2"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="*"
IUSE="doc"

RDEPEND="dev-libs/gmp:0=
	>=dev-libs/mpc-1.0:0=
	>=dev-libs/mpfr-3.1:0="
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	distutils_src_prepare
	sed -e "s/if sys.version.startswith('3.1'):/if False:/" -i test/runtests.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_test() {
	testing() {
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" test/runtests.py || return
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" test$(python_get_version -l --major)/gmpy_test.py || return
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/_build/html/
	fi
}
