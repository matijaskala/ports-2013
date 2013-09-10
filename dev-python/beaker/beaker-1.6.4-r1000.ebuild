# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
# https://bitbucket.org/bbangert/beaker/issue/94
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="2.5 3.* *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="Beaker"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Session and Caching library with WSGI Middleware"
HOMEPAGE="http://beaker.readthedocs.org/ https://github.com/bbangert/beaker http://pypi.python.org/pypi/Beaker"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"

# Disabled tests from tests/test_memcached.py require dev-python/mock.
DEPEND="$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend -e "2.5 3.1" dev-python/webtest) )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

src_prepare() {
	# Workaround for potential future fix for http://bugs.python.org/issue11276.
	# https://bitbucket.org/bbangert/beaker/issue/85
	sed -e "/import anydbm/a dbm = anydbm" -i beaker/container.py

	# Skip Memcached tests.
	sed -e "/from nose import SkipTest/a raise SkipTest" -i tests/test_memcached.py

	distutils_src_prepare

	prepare_tests() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			2to3-${PYTHON_ABI} -nw --no-diffs tests
		fi
	}
	python_execute_function -s prepare_tests
}
