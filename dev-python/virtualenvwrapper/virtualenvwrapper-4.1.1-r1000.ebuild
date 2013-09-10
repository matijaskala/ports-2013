# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
PYTHON_NAMESPACES="virtualenvwrapper"

inherit distutils python-namespaces

DESCRIPTION="Enhancements to virtualenv"
HOMEPAGE="http://www.doughellmann.com/projects/virtualenvwrapper/ https://pypi.python.org/pypi/virtualenvwrapper"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="test"

RDEPEND="$(python_abi_depend dev-python/stevedore)
	$(python_abi_depend dev-python/virtualenv)
	dev-python/virtualenv-clone"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/pbr)
	$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${P}"

src_install() {
	distutils_src_install
	python-namespaces_src_install
}

pkg_postinst() {
	distutils_pkg_postinst
	python-namespaces_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	python-namespaces_pkg_postrm
}
