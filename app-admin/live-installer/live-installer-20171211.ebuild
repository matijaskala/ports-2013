# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT_ID="60e3a97efa4f666dec5f2e9bef334f0d1b0e6527"
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
