# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT_ID="40b20b49091d74890593b6f5c0e201cff130885e"
DESCRIPTION="Linux Mint Live Installer"
HOMEPAGE="https://github.com/matijaskala/live-installer"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
S=${WORKDIR}/${PN}-${COMMIT_ID}
RESTRICT="mirror"

RDEPEND="
	dev-python/pillow
	dev-python/pyparted
	x11-apps/setxkbmap"

src_install() {
	mv ${S}/etc "${ED}" || die
	mv ${S}/usr "${ED}" || die

	rm "${ED}"/usr/share/icons/live-installer.xpm || die
	cp -r "${ED}"/usr/share/icons "${ED}"/usr/share/pixmaps || die
}
