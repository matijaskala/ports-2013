# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/epstool/epstool-3.08-r1.ebuild,v 1.5 2013/09/14 10:01:15 ago Exp $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Creates or extracts preview images in EPS files, fixes bounding boxes,converts to bitmaps."
HOMEPAGE="http://www.cs.wisc.edu/~ghost/gsview/epstool.htm"
SRC_URI="ftp://mirror.cs.wisc.edu/pub/mirrors/ghost/ghostgum/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="app-text/ghostscript-gpl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/gcc43.patch"

	sed -i \
		-e '/^CC/s/=/?=/' \
		-e '/^CLINK/s/gcc/$(CC)/' \
		src/unixcom.mak || die 'sed on src/unixcom.mak failed'
	tc-export CC

	epatch_user
}

src_compile() {
	emake epstool
}

src_install() {
	dobin bin/epstool
	doman doc/epstool.1
	dohtml doc/epstool.htm doc/gsview.css
}
