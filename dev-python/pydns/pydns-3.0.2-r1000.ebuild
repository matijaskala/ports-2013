# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.*"

inherit distutils

MY_PN="py3dns"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python module for DNS (Domain Name Service)"
HOMEPAGE="http://pydns.sourceforge.net/ https://pypi.python.org/pypi/pydns"
SRC_URI="mirror://sourceforge/pydns/${MY_P}.tar.gz"

LICENSE="CNRI"
SLOT="3"
KEYWORDS="*"
IUSE="examples"

RDEPEND="!dev-python/py3dns
	!dev-python/pydns:python-3"
DEPEND="${RDEPEND}
	virtual/libiconv"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES CREDITS"
PYTHON_MODULES="DNS"

src_prepare() {
	distutils_src_prepare

	# Clean documentation.
	mv CREDITS.txt CREDITS
	mv README.txt README
	rm -f README-guido.txt
}

src_install(){
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins {tests,tools}/*.py
	fi
}
