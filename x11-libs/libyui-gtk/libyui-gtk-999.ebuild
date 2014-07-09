# Copyright 2014 Matija Skala
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-r3

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""
EGIT_REPO_URI="git://github.com/libyui/${PN}.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="x11-libs/gtk+
	dev-python/pygtk
	x11-libs/libyui
"
RDEPEND="${DEPEND}"

src_prepare() {
	./bootstrap.sh
}
