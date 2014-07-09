# Copyright 2014 Matija Skala
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-r3

DESCRIPTION=""
HOMEPAGE=""
EGIT_REPO_URI="git://github.com/libyui/libyui.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt4 ncurses gtk"

DEPEND=""
RDEPEND="${DEPEND}"
REQUIRED_USE="|| ( qt4 ncurses gtk )"
PDEPEND="
	qt4? ( x11-libs/libyui-qt )
	ncurses? ( x11-libs/libyui-ncurses )
	gtk? ( x11-libs/libyui-gtk )
	"

src_prepare() {
	./bootstrap.sh
}
