# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://github.com/yast/${PN}.git"

inherit git-r3

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-ruby/yard
	dev-ruby/yast-rake
	dev-util/yast-devtools"

RDEPEND="${DEPEND}"

src_compile() {
	yardoc
	rake
}

src_install() {
	rake install DESTDIR="${ED}"
}
