# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NetBSD command to read man pages"
HOMEPAGE="https://www.netbsd.org"
COMMIT_ID="6829c0809707657b5cfd504699034716a331d689"
SRC_URI="https://github.com/matijaskala/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libbsd"
RDEPEND="${DEPEND}
	!sys-apps/grep
	!sys-freebsd/freebsd-ubin"

S=${WORKDIR}/${PN}-${COMMIT_ID}
