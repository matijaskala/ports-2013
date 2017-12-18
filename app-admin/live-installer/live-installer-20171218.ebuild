# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT_ID="40b20b49091d74890593b6f5c0e201cff130885e"
DESCRIPTION="Linux Mint Live Installer"
HOMEPAGE="https://github.com/matijaskala/live-installer"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}/${PN}-${COMMIT_ID}
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pillow
	dev-python/pyparted
	x11-apps/setxkbmap"

src_install() {
	mv ${S}/etc ${ED}
	mv ${S}/usr ${ED}
}
