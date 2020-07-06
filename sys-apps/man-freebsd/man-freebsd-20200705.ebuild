# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="FreeBSD commands to read man pages"
HOMEPAGE="https://www.freebsd.org"
COMMIT_ID="192e1a305f792e94117854d10d1902db7db045e4"
SRC_URI="https://github.com/matijaskala/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+manpager"
RESTRICT="mirror"

RDEPEND="userland_GNU? ( sys-apps/which )
	sys-apps/groff
	!sys-apps/man
	!sys-apps/man-db
	!sys-apps/man-netbsd
	!sys-freebsd/freebsd-ubin"
PDEPEND="manpager? ( app-text/manpager )"

S=${WORKDIR}/${PN}-${COMMIT_ID}

src_prepare() {
	default

	tc-export CC
}
