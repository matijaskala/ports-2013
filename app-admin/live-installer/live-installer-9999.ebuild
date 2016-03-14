# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Linux Mint Live Installer"
HOMEPAGE="https://github.com/matijaskala/live-installer"
EGIT_REPO_URI="git://github.com/matijaskala/${PN}"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
#S=${WORKDIR}/${PN}
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pillow
	dev-python/pyparted
	dev-python/pywebkitgtk"

src_install() {
	mv ${S}/etc ${ED}
	mv ${S}/usr ${ED}
}
