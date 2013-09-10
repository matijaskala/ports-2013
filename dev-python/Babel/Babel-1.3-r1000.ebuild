# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.1 3.2"
DISTUTILS_SRC_TEST="py.test"

inherit distutils eutils

DESCRIPTION="A collection of tools for internationalizing Python applications"
HOMEPAGE="http://babel.pocoo.org/ https://github.com/mitsuhiko/babel https://pypi.python.org/pypi/Babel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND="$(python_abi_depend dev-python/pytz)
	$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

PYTHON_MODULES="babel"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-tests.patch"

	# https://github.com/mitsuhiko/babel/issues/46
	sed -e "s/utf_8/utf-8/" -i babel/util.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/_build/html/
	fi
}
