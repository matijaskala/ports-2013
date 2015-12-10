# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2-utils

DESCRIPTION="Unity desktop icon theme"
HOMEPAGE="https://launchpad.net/unity-asset-pool"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}daily13.06.10.orig.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
S=${WORKDIR}/${P}daily13.06.10
RESTRICT="mirror"

RDEPEND=">=x11-themes/gnome-icon-theme-3.8
	x11-themes/hicolor-icon-theme"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	>=sys-devel/gettext-0.15"

src_install() {
	insinto /usr/share/unity/themes
	doins -r launcher/* panel/*

	insinto /usr/share/icons
	doins -r unity-icon-theme unity-webapps-applications

	insinto /usr/share/icons/hicolor/32x32/apps
	doins account-plugins-icons/*

	insinto /usr/share/icons/hicolor/128x128/apps
	doins unity-webapps-applications/apps/128/*

	dodoc COPYRIGHT
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
