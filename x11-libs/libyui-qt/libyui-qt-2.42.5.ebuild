# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libyui-qt/libyui-qt-2.21.1.ebuild,v 1.4 2013/03/02 23:44:58 hwoarang Exp $

EAPI=4

inherit cmake-utils git-r3

DESCRIPTION="UI abstraction library - Qt plugin"
HOMEPAGE="http://sourceforge.net/projects/libyui/"
#EGIT_REPO_URI="git://github.com/libyui/libyui-qt.git"
SRC_URI="https://github.com/libyui/${PN}/archive/master/${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-master

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-qt/qtgui:4
	x11-libs/libyui
"
RDEPEND="${DEPEND}"

src_prepare() {
	./bootstrap.sh
}
