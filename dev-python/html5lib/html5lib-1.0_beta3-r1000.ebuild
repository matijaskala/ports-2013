# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}xml]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_P="${PN}-${PV/_beta/b}"

DESCRIPTION="HTML parser based on the WHATWG HTML specification"
HOMEPAGE="https://github.com/html5lib/html5lib-python https://pypi.python.org/pypi/html5lib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="charade genshi lxml"

DEPEND="$(python_abi_depend -i "2.6" dev-python/ordereddict)
	$(python_abi_depend dev-python/six)
	charade? ( $(python_abi_depend dev-python/charade) )
	genshi? ( $(python_abi_depend dev-python/genshi) )
	lxml? ( $(python_abi_depend -e "*-pypy-*" dev-python/lxml ) )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
