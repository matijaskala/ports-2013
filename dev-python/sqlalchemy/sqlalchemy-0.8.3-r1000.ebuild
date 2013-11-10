# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_BDEPEND="test? ( <<[{*-cpython *-pypy-*}sqlite]>> )"
PYTHON_DEPEND="<<[{*-cpython *-pypy-*}sqlite?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="http://www.sqlalchemy.org/ https://pypi.python.org/pypi/SQLAlchemy"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples firebird mssql mysql postgres +sqlite test"

RDEPEND="$(python_abi_depend dev-python/setuptools)
	firebird? ( $(python_abi_depend -e "3.* *-jython *-pypy-*" dev-python/kinterbasdb) )
	mssql? ( $(python_abi_depend -e "3.* *-jython *-pypy-*" dev-python/pymssql) )
	mysql? ( $(python_abi_depend -e "3.* *-jython" dev-python/mysql-python) )
	postgres? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-python/psycopg:2) )"
DEPEND="${RDEPEND}
	test? ( $(python_abi_depend -e "${PYTHON_TESTS_RESTRICTED_ABIS}" virtual/python-mock) )"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DISTUTILS_GLOBAL_OPTIONS=("2.*-cpython --with-cextensions")

src_prepare() {
	distutils_src_prepare

	# Disable tests hardcoding function call counts specific to Python versions.
	rm -fr test/aaa_profiling

	# Not needed in SQLAlchemy >=0.9.
	if [[ "${PV}" == 0.8.* ]]; then
		sed -e "/^where = test$/d" -i setup.cfg

		preparation() {
			cp -r test test-${PYTHON_ABI} || return
			if [[ "$(python_get_version -l --major)" == "3" ]]; then
				"$(PYTHON)" sa2to3.py -nw --no-diffs test-${PYTHON_ABI} || return
			fi
		}
		python_execute_function preparation
	fi
}

src_test() {
	testing() {
		# Based on sqla_nose.py.
		# '-w test-${PYTHON_ABI}' not needed in SQLAlchemy >=0.9.
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*):$(ls -d build-${PYTHON_ABI}/lib*/sqlalchemy/testing/plugin)" "$(PYTHON)" -c "import nose, noseplugin; nose.main(addplugins=[noseplugin.NoseSQLAlchemy()])" -w test-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc; then
		rm -fr doc/build
		dohtml -r doc/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
