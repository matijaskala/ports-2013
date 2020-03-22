# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FreeBSD utility to apply diffs to files"
HOMEPAGE="https://www.netbsd.org"
COMMIT_ID="9079f458556872a07c2478780d373b570635d167"
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

	mv "${D}"/usr/bin/patch "${D}"/usr/bin/bsdpatch || die
	mv "${D}"/usr/share/man/man1/patch.1 "${D}"/usr/share/man/man1/bsdpatch.1 || die
}
