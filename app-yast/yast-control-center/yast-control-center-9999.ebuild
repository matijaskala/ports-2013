# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="Yet another Setup Tool (YaST)"
HOMEPAGE=""
SRC_URI=""

EGIT_REPO_URI="git://github.com/yast/${PN}.git"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
