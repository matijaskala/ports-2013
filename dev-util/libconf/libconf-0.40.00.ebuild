# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="xml"

MY_P=perl-${PN/l/L}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Centralized abstraction layer for system configuration files"
HOMEPAGE="http://libconf.net/"
SRC_URI="http://damien.krotkine.com/libconf/dist/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"

DEPEND="dev-lang/perl
	dev-perl/DelimMatch
	xml? ( dev-perl/Data-DumpXML )"

src_compile() {
	emake || die
	emake -j1 test || die
}

src_install() {
	einstall PREFIX="${D}/usr"
	dodoc AUTHORS ChangeLog
}
