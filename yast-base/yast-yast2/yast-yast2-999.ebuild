# Copyright 2014 Matija Skala
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit yast

DESCRIPTION="Yet another Setup Tool (YaST)"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-tcltk/expect
	dev-util/dejagnu"

src_install() {
	default
	rm -rf ${ED}/sbin || die
}
