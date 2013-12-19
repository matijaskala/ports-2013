# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/antimicro/antimicro-1.2.ebuild,v 1.1 2013/12/14 22:00:20 hasufell Exp $

EAPI=5
inherit eutils qt4-r2

DESCRIPTION="Map keyboard and mouse buttons to gamepad buttons"
HOMEPAGE="https://github.com/Ryochan7/antimicro"
SRC_URI="https://github.com/Ryochan7/antimicro/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/libsdl:0[joystick]
	x11-libs/libX11
	x11-libs/libXtst"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/src

src_prepare() {
	cd "${WORKDIR}/${P}" || die
	epatch "${FILESDIR}"/${P}-desktopfile.patch
}

src_configure() {
	eqmake4 INSTALL_PREFIX=/usr antimicro.pro
}

src_compile() {
	emake
	emake updateqm
}
