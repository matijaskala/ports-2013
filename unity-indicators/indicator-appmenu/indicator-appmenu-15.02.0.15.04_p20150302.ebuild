# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils flag-o-matic gnome2 ubuntu

DESCRIPTION="An indicator to host the menus from an application."
HOMEPAGE="https://launchpad.net/indicator-appmenu"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	x11-libs/bamf:=
	dev-libs/libappindicator
	>=x11-libs/gtk+-3.5.12:3
	x11-libs/libwnck:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
	append-cflags -Wno-error
}
