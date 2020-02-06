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
	!sys-apps/diffutils
	!sys-freebsd/freebsd-ubin"

S=${WORKDIR}/${PN}-${COMMIT_ID}
