# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit db-use distutils multilib

DESCRIPTION="Python interface for Berkeley DB"
HOMEPAGE="http://www.jcea.es/programacion/pybsddb.htm https://pypi.python.org/pypi/bsddb3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND=">=sys-libs/db-4.8:="
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="ChangeLog TODO.txt"

src_configure() {
	for DB_VER in 6.0 5.3 5.2 5.1 5.0 4.8; do
		if has_version sys-libs/db:${DB_VER}; then
			break
		fi
	done

	sed -e "s/dblib = 'db'/dblib = '$(db_libname ${DB_VER})'/" -i setup2.py setup3.py || die "sed failed"
}

src_compile() {
	distutils_src_compile \
		--berkeley-db="${EPREFIX}/usr" \
		--berkeley-db-incdir="${EPREFIX}$(db_includedir ${DB_VER})" \
		--berkeley-db-libdir="${EPREFIX}/usr/$(get_libdir)"
}

src_test() {
	tests() {
		rm -f build
		ln -s build-${PYTHON_ABI} build

		python_execute TMPDIR="${T}/tests-${PYTHON_ABI}" "$(PYTHON)" test.py -vv
	}
	python_execute_function tests
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/bsddb3/tests"
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r docs/html/*
	fi
}
