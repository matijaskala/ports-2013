# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils flag-o-matic

DESCRIPTION="Python bindings for libcups"
HOMEPAGE="http://cyberelk.net/tim/software/pycups/ https://pypi.python.org/pypi/pycups"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples"

RDEPEND="net-print/cups"
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc )"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_compile() {
	append-cflags -DVERSION=\\\"${PV}\\\"
	distutils_src_compile

	if use doc; then
		emake doc
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r html/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples/
	fi
}
