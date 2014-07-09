# Copyright 2014 Matija Skala
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit yast

DESCRIPTION="Yet another Setup Tool (YaST)"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-doc/doxygen"

src_prepare() {
	epatch "${FILESDIR}"/libxcrypt.patch
	yast_src_prepare
}
