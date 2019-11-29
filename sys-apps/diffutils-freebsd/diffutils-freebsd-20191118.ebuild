# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FreeBSD tools to compare files"
HOMEPAGE="https://www.freebsd.org"
COMMIT_ID="52efc6b0e3a3c8c2665440fbd42a5e57ae86b5b5"
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

	mv "${D}"/usr/bin/cmp "${D}"/usr/bin/bsdcmp || die
	mv "${D}"/usr/bin/diff "${D}"/usr/bin/bsddiff || die
	mv "${D}"/usr/bin/diff3 "${D}"/usr/bin/bsddiff3 || die
	mv "${D}"/usr/bin/sdiff "${D}"/usr/bin/bsdsdiff || die
	mv "${D}"/usr/share/man/man1/cmp.1 "${D}"/usr/share/man/man1/bsdcmp.1 || die
	mv "${D}"/usr/share/man/man1/diff.1 "${D}"/usr/share/man/man1/bsddiff.1 || die
	mv "${D}"/usr/share/man/man1/diff3.1 "${D}"/usr/share/man/man1/bsddiff3.1 || die
	mv "${D}"/usr/share/man/man1/sdiff.1 "${D}"/usr/share/man/man1/bsdsdiff.1 || die
}
