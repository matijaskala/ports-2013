# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_DEPEND="<<[{3.*-cpython *-pypy-*}sqlite]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit python

DESCRIPTION="Virtual for pysqlite2 and sqlite3 Python modules"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="external"

DEPEND=""
RDEPEND="python_abis_2.5? (
		external? ( dev-python/pysqlite:2[python_abis_2.5] )
		!external? ( || ( dev-lang/python:2.5[sqlite] dev-python/pysqlite:2[python_abis_2.5] ) )
	)
	python_abis_2.6? (
		external? ( dev-python/pysqlite:2[python_abis_2.6] )
		!external? ( || ( dev-lang/python:2.6[sqlite] dev-python/pysqlite:2[python_abis_2.6] ) )
	)
	python_abis_2.7? (
		external? ( dev-python/pysqlite:2[python_abis_2.7] )
		!external? ( || ( dev-lang/python:2.7[sqlite] dev-python/pysqlite:2[python_abis_2.7] ) )
	)"
