# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"

inherit distutils eutils

DESCRIPTION="Firebird/Interbase interface for Python."
HOMEPAGE="http://kinterbasdb.sourceforge.net/"
SRC_URI="mirror://sourceforge/firebird/${P}.tar.gz"

LICENSE="kinterbasdb"
SLOT="0"
KEYWORDS="amd64 -sparc x86"
IUSE="doc"

DEPEND=">=dev-db/firebird-1.0_rc1
	$(python_abi_depend ">=dev-python/egenix-mx-base-2.0.1")"
RDEPEND="${DEPEND}"

DOCS="docs/changelog.txt"

src_prepare() {
	distutils_src_prepare

	# Set location of Firebird headers.
	sed -e "s:^#\(database_include_dir=\).*:\1/usr/include:" -i setup.cfg || die "sed failed"

	epatch "${FILESDIR}/${PN}-3.2-no_doc.patch"
}

src_install() {
	distutils_src_install

	use doc && dohtml docs/*
}
