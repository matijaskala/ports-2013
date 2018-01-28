# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils versionator

MY_PV="$(get_version_component_range '1-2')"
DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="http://www.glx-dock.org"
SRC_URI="http://launchpad.net/${PN}-core/${MY_PV}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="desktop-manager xcomposite"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2:2
	gnome-base/librsvg:2
	net-misc/curl
	sys-apps/dbus
	x11-libs/cairo
	>=x11-libs/gtk+-3.4.0
	x11-libs/gtkglext
	x11-libs/libXrender
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXinerama
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		"-Denable-desktop-manager=$(usex desktop-manager ON OFF)"
		"-DWITH_XEXTEND=$(usex xcomposite)"
	)
	cmake-utils_src_configure
}
