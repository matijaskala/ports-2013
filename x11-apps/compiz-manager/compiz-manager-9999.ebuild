# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A wrapper script to start Compiz 0.8.x with proper options"
HOMEPAGE="https://gitlab.com/compiz"
EGIT_REPO_URI="https://github.com/compiz-reloaded/compiz-manager.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

RDEPEND="x11-apps/mesa-progs
	x11-apps/xdpyinfo
	>=x11-wm/compiz-0.8.12
	<x11-wm/compiz-0.9
"

src_install() {
	dobin compiz-manager
}
