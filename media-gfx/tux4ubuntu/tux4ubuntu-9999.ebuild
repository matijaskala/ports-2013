# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Tux theme for Plymouth"
HOMEPAGE="https://tux4ubuntu.blogspot.com"
EGIT_REPO_URI="git://github.com/tuxedojoe/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-boot/plymouth"

src_install() {
	insinto /usr/share/plymouth/themes
	doins -r tux-plymouth-theme
}
