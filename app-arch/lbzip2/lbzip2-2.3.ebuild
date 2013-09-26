# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lbzip2/lbzip2-2.3.ebuild,v 1.1 2013/09/23 11:18:45 jlec Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Parallel bzip2 utility"
HOMEPAGE="https://github.com/kjn/lbzip2/"
SRC_URI="http://archive.lbzip2.org/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug symlink"

PATCHES=( "${FILESDIR}"/${P}-s_isreg.patch )

RDEPEND="symlink? ( !app-arch/pbzip2[symlink] )"
DEPEND=""

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		$(use_enable debug tracing)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	use symlink && dosym ${PN} /usr/bin/bzip2
}
