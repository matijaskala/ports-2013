# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenBSD utilities for finding files"
HOMEPAGE="https://www.openbsd.org"
COMMIT_ID="1066214bd4a9c0d9e9dd8b1b13cd1db0c34fe971"
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

src_install() {
	default

	if [[ ${USERLAND} == GNU ]] ; then
		mv "${D}"/usr/bin/find "${D}"/usr/bin/bsdfind || die
		mv "${D}"/usr/bin/xargs "${D}"/usr/bin/bsdxargs || die
		mv "${D}"/usr/share/man/man1/find.1 "${D}"/usr/share/man/man1/bsdfind.1 || die
		mv "${D}"/usr/share/man/man1/xargs.1 "${D}"/usr/share/man/man1/bsdxargs.1 || die
	fi
}
