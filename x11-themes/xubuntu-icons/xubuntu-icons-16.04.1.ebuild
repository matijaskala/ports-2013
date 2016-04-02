# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Xubuntu icon theme"
HOMEPAGE="https://launchpad.net/xubuntu-artwork"
SRC_URI="mirror://ubuntu/pool/universe/x/xubuntu-artwork/xubuntu-artwork_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}/trunk

RDEPEND=""
DEPEND="app-arch/xz-utils"

RESTRICT="binchecks strip"

src_install() {
	insinto /usr/share/icons
	doins -r usr/share/icons/elementary-xfce*
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
