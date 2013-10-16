# Distributed under the terms of the GNU General Public License v2

EAPI="2"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="An indicator to host the menus from an application."
HOMEPAGE="https://launchpad.net/indicator-appmenu"
SRC_URI="http://launchpad.net/${PN}/0.3/${PV}/+download/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="gtk3 nls"

RDEPEND=">=x11-libs/gtk+-2.12:2
        gtk3? (
        >=x11-libs/gtk+-3.2.1:3
        >=x11-libs/libwnck-3.2.1 )
        >=dev-libs/dbus-glib-0.76
        >=dev-libs/libindicator-0.4.1
        >=dev-libs/libdbusmenu-0.5.0[json]"
DEPEND="${RDEPEND}
        virtual/pkgconfig
        nls? ( dev-util/intltool )
        x11-libs/bamf"

src_configure() {
        econf \
                --with-gtk=$(usex gtk3 "3" "2")
}
