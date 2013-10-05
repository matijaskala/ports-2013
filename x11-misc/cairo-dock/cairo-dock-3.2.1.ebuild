# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit cmake-utils versionator

MY_PV="$(get_version_component_range '1-2')"
DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="http://www.glx-dock.org"
SRC_URI="http://launchpad.net/${PN}-core/${MY_PV}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="experimental"
IUSE="gtk3 xcomposite"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/libxml2:2
	net-misc/curl
	x11-libs/gtk+:2
	x11-libs/gtkglext
	x11-libs/libXrender
	gtk3? ( x11-libs/gtk+:3 )
	xcomposite? (
		x11-libs/libXcomposite
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
		"$(usex gtk3 "" "-Dforce-gtk2=yes")"
		"$(cmake-utils_use_with xcomposite XEXTEND)"
	)
	cmake-utils_src_configure
}
