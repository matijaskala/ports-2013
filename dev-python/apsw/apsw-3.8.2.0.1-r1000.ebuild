# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"
# http://code.google.com/p/apsw/issues/detail?id=129
PYTHON_TESTS_RESTRICTED_ABIS="*-pypy-*"

inherit distutils eutils

SQLITE_PV="$(shopt -s extglob; echo "${PV/%.?(0.)*([^.])/}")"
MY_PV="${SQLITE_PV}-r${PV##*.}"

DESCRIPTION="APSW - Another Python SQLite Wrapper"
HOMEPAGE="http://code.google.com/p/apsw/"
SRC_URI="http://apsw.googlecode.com/files/${PN}-${MY_PV}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~*"
IUSE="doc"

DEPEND=">=dev-db/sqlite-${SQLITE_PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-3.6.20.1-fix_tests.patch"

	# http://code.google.com/p/apsw/source/browse/src/pypycompat.c
	cat << EOF > src/pypycompat.c
/* Recycle depends on CPython GC */
#define AB_NRECYCLE 0
EOF
}

src_compile() {
	distutils_src_compile --enable=load_extension
}

src_test() {
	python_execute "$(PYTHON -f)" setup.py build_test_extension || die "Building of test loadable extension failed"

	testing() {
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" tests.py -v
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/
	fi
}
