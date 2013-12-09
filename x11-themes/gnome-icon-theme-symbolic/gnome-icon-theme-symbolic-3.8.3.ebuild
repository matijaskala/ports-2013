# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-icon-theme-symbolic/gnome-icon-theme-symbolic-3.8.3.ebuild,v 1.4 2013/12/08 19:52:17 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Symbolic icons for GNOME default icon theme"
HOMEPAGE="https://git.gnome.org/browse/gnome-icon-theme-symbolic/"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"

COMMON_DEPEND=">=x11-themes/hicolor-icon-theme-0.10"

RDEPEND="${COMMON_DEPEND}
	!=gnome-extra/gnome-power-manager-3.0*
	!=gnome-extra/gnome-power-manager-3.1*
"
# keyboard-brightness icon file collision with old gnome-power-manager
DEPEND="${COMMON_DEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_configure() {
	gnome2_src_configure \
		--enable-icon-mapping \
		GTK_UPDATE_ICON_CACHE=$(type -P true)
}
