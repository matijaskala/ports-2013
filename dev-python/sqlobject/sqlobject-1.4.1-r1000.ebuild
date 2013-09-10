# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils

MY_PN="SQLObject"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Object-Relational Manager, aka database wrapper"
HOMEPAGE="http://sqlobject.org/ https://pypi.python.org/pypi/SQLObject"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="doc firebird mysql postgres sqlite"

RDEPEND="$(python_abi_depend dev-python/formencode)
		firebird? ( $(python_abi_depend -e "*-pypy-*" dev-python/kinterbasdb) )
		mysql? ( $(python_abi_depend dev-python/mysql-python) )
		postgres? ( $(python_abi_depend -e "*-pypy-*" dev-python/psycopg:2) )
		sqlite? ( $(python_abi_depend virtual/python-sqlite[external]) )"
DEPEND="${RDEPEND}
		$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install

	if use doc; then
		pushd docs > /dev/null
		dodoc *.txt
		dohtml -r presentation-2004-11
		insinto /usr/share/doc/${PF}
		doins -r europython
		popd > /dev/null
	fi
}
