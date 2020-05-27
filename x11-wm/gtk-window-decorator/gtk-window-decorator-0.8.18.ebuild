# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils

DESCRIPTION="GTK window decorator"
HOMEPAGE="https://gitlab.com/compiz"
SRC_URI="https://github.com/compiz-reloaded/compiz/archive/v${PV}.tar.gz -> compiz-${PV}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="dbus gsettings +gtk3 mate"
RESTRICT="mirror"
S=${WORKDIR}/compiz-${PV}

DEPEND="
	>=dev-libs/glib-2
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/mesa
	x11-base/xorg-server
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/libXrender-0.9.3
	>=x11-libs/startup-notification-0.7
	virtual/glu
	dbus? ( dev-libs/dbus-glib )
	gsettings? ( >=dev-libs/glib-2.32 )
	gtk3? (
		x11-libs/gtk+:3
		x11-libs/libwnck:3
	)
	!gtk3? (
		>=x11-libs/gtk+-2.22.0:2
		>=x11-libs/libwnck-2.22.0:1
	)
	mate? ( >=x11-wm/marco-1.22.2[gtk3(+)=] )
"

RDEPEND="${DEPEND}
	~x11-wm/compiz-${PV}
"

BDEPEND="
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-static
		--disable-annotate
		--disable-compizconfig
		--disable-dbus
		$(use_enable dbus dbus-glib)
		$(use_enable gsettings)
		--disable-fuse
		--enable-gsettings
		--disable-librsvg
		$(use_enable mate marco)
		--disable-mate
		--enable-gtk
		--with-gtk=$(usex gtk3 3.0 2.0)
	)

	econf "${myconf[@]}"
}

src_install() {
	dobin gtk-window-decorator/.libs/gtk-window-decorator
	insinto /usr/share/glib-2.0/schemas
	doins gtk-window-decorator/org.compiz-0.gwd.gschema.xml
}

pkg_postinst() {
	gnome2_icon_cache_update
	use gsettings && gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	use gsettings && gnome2_schemas_update
}
