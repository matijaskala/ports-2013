# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

DESCRIPTION="Platform-independent file locking module"
HOMEPAGE="https://github.com/smontanaro/pylockfile http://code.google.com/p/pylockfile/ https://pypi.python.org/pypi/lockfile"
SRC_URI="http://pylockfile.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

DEPEND="doc? ( $(python_abi_depend dev-python/sphinx) )"
RDEPEND=""

DOCS="ACKS README RELEASE-NOTES"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-python-3.patch"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/.build/html/
	fi
}
