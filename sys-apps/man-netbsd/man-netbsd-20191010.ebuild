# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NetBSD command to read man pages"
HOMEPAGE="https://www.netbsd.org"
COMMIT_ID="b57a8c834b2e4fc4ae40fed58249e0598267a42f"
SRC_URI="https://github.com/matijaskala/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libbsd"
RDEPEND="${DEPEND}
	app-text/mandoc
	!sys-apps/man
	!sys-apps/man-db
	!sys-apps/man-freebsd
	!sys-freebsd/freebsd-bin"

S=${WORKDIR}/${PN}-${COMMIT_ID}

src_prepare() {
	default

	tc-export CC
}
