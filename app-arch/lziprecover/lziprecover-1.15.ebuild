# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lziprecover/lziprecover-1.15.ebuild,v 1.1 2013/10/21 13:44:11 polynomial-c Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Lziprecover is a data recovery tool and decompressor for files in the lzip compressed data format."
HOMEPAGE="http://www.nongnu.org/lzip/lziprecover.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/lzip/${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}
