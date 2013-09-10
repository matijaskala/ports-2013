# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.1"

inherit distutils

MY_PN="pyOpenSSL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="http://pyopenssl.sourceforge.net/ https://launchpad.net/pyopenssl https://pypi.python.org/pypi/pyOpenSSL"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}
	doc? (
		=dev-lang/python-2*
		dev-tex/latex2html[gif,png]
	)"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

PYTHON_MODULES="OpenSSL"

src_prepare() {
	distutils_src_prepare

	sed -e "s/python/&2/" -i doc/Makefile
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		addwrite /var/cache/fonts
		pushd doc > /dev/null
		emake -j1 html ps dvi
		popd > /dev/null
	fi
}

src_test() {
	test_package() {
		pushd OpenSSL/test > /dev/null

		local exit_status="0" test
		for test in test_*.py; do
			if ! python_execute PYTHONPATH="$(ls -d ../../build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" "${test}"; then
				eerror "${test} failed with $(python_get_implementation_and_version)"
				exit_status="1"
			fi
		done

		popd > /dev/null

		return "${exit_status}"
	}
	python_execute_function test_package
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/OpenSSL/test"
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r doc/html/
		dodoc doc/pyOpenSSL.*
	fi

	insinto /usr/share/doc/${PF}/examples
	doins -r examples/*
}
