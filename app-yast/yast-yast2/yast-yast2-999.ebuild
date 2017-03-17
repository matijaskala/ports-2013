# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit yast

DESCRIPTION="Yet another Setup Tool (YaST)"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-tcltk/expect
	dev-util/dejagnu"

src_install() {
	MAKEOPTS="${MAKEOPTS} -j1"
	default
	rm -rf ${ED}/sbin || die
}
