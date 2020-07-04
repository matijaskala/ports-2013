# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="BSD utilities for finding files"
HOMEPAGE="https://www.freebsd.org"
COMMIT_ID="dc033b97d4d2ac34a50307144192321a2715f995"
SRC_URI="https://github.com/matijaskala/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libbsd"
RDEPEND="${DEPEND}
	!sys-freebsd/freebsd-ubin"

S=${WORKDIR}/${PN}-${COMMIT_ID}

src_prepare() {
	default

	tc-export CC
}

src_install() {
	default

	if [[ ${USERLAND} == GNU ]] ; then
		mv "${D}"/usr/bin/find "${D}"/usr/bin/bsdfind || die
		mv "${D}"/usr/bin/xargs "${D}"/usr/bin/bsdxargs || die
		mv "${D}"/usr/share/man/man1/find.1 "${D}"/usr/share/man/man1/bsdfind.1 || die
		mv "${D}"/usr/share/man/man1/xargs.1 "${D}"/usr/share/man/man1/bsdxargs.1 || die
	fi
}
