# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Unity desktop icon theme"
HOMEPAGE="https://launchpad.net/unity-asset-pool"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.10.}.orig.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
S=${WORKDIR}
RESTRICT="mirror"

RDEPEND="x11-themes/adwaita-icon-theme
	x11-themes/hicolor-icon-theme"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_install() {
	insinto /usr/share/unity/themes
	doins -r launcher/* panel/*

	insinto /usr/share/icons
	doins -r unity-icon-theme

	dodoc COPYRIGHT
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
