# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A stream editor from NetBSD"
HOMEPAGE="https://www.netbsd.org"
COMMIT_ID="38fde09fdc006bb6719547c245f93a87def25a56"
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

	if [[ ${USERLAND} != BSD ]] ; then
		mv "${D}"/usr/bin/sed "${D}"/usr/bin/bsdsed || die
		mv "${D}"/usr/share/man/man1/sed.1 "${D}"/usr/share/man/man1/bsdsed.1 || die
	fi
}
