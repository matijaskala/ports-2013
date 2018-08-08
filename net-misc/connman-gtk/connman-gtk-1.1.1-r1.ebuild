# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils

DESCRIPTION="GTK GUI for Connman"
HOMEPAGE="https://github.com/jgke/connman-gtk"
SRC_URI="https://github.com/jgke/connman-gtk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="openconnect"

CDEPEND="
	>=dev-libs/glib-2.0:2
	>=x11-libs/gtk+-3.10:3
	openconnect? ( >=net-vpn/openconnect-5.99 )
"
RDEPEND="${CDEPEND}
	net-misc/connman
"
DEPEND="${CDEOEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i -e '/^Categories/ s/$/;/' connman-gtk.desktop.in || die
	sed -i -e '/^Exec/ s/$/ --no-icon/' connman-gtk.desktop.in || die
	patch -p1 << EOF
--- a/net.connman.gtk.gschema.xml
+++ b/net.connman.gtk.gschema.xml
@@ -0,7 +0,7 @@
 <schemalist>
 	<schema path="/net/connman/gtk/" id="net.connman.gtk">
 		<key name="status-icon-enabled" type="b">
-			<default>false</default>
+			<default>true</default>
 		</key>
 		<key name="launch-to-tray" type="b">
 			<default>false</default>
EOF
	sed -i -e '/launch_to_tray =/d' src/config.c || die
	eautoreconf
}

src_configure() {
	default
	econf \
		--disable-schemas-compile \
		$(use_with openconnect)
}

src_install() {
	default
	insinto /etc/xdg/autostart
	newins - connman-gtk.desktop << EOF
[Desktop Entry]
Type=Application
Exec=${PN} --tray
Name=Connman
NotShowIn=KDE,GNOME;
Icon=preferences-system-network
EOF
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
