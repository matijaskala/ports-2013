# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NetBSD command to read man pages"
HOMEPAGE="https://www.netbsd.org"
COMMIT_ID="8c1eed46d3cb5ace7f6c4daffd8c47ee7290e060"
SRC_URI="https://github.com/matijaskala/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libbsd"
RDEPEND="${DEPEND}
	!sys-apps/sed
	!sys-freebsd/freebsd-ubin"

S=${WORKDIR}/${PN}-${COMMIT_ID}
