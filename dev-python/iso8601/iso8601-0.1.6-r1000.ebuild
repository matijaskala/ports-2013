# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# *-jython: http://bugs.jython.org/issue1973
PYTHON_RESTRICTED_ABIS="*-jython"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="Simple module to parse ISO 8601 dates"
HOMEPAGE="https://bitbucket.org/micktwomey/pyiso8601 https://pypi.python.org/pypi/iso8601"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

src_test() {
	python_execute_py.test iso8601
}
