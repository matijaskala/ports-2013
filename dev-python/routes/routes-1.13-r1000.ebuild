# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="Routes"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Routing Recognition and Generation Tools"
HOMEPAGE="https://routes.readthedocs.org/ https://pypi.python.org/pypi/Routes"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

DEPEND="$(python_abi_depend dev-python/repoze.lru)
	$(python_abi_depend dev-python/setuptools)
	$(python_abi_depend dev-python/webob)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/_build/html/
	fi
}
