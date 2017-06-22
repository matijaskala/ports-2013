# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils gnome2-utils

DESCRIPTION="OpenGL window and compositing manager"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="+cairo dbus fuse +gtk mate +svg"
RESTRICT="mirror"

COMMONDEPEND="
	>=dev-libs/glib-2
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/libpng:0=
	media-libs/mesa
	x11-base/xorg-server
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/libXrender-0.8.4
	>=x11-libs/startup-notification-0.7
	virtual/glu
	cairo? (
		x11-libs/cairo[X]
	)
	dbus? (
		>=sys-apps/dbus-1.0
		dev-libs/dbus-glib
	)
	fuse? ( sys-fs/fuse )
	svg? (
		>=gnome-base/librsvg-2.14.0:2
		>=x11-libs/cairo-1.0
	)
"

DEPEND="${COMMONDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto
"

RDEPEND="${COMMONDEPEND}
	x11-apps/mesa-progs
	x11-apps/xdpyinfo
	x11-apps/xset
	x11-apps/xvinfo
"

PDEPEND="gtk? ( x11-wm/gtk-window-decorator )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable cairo annotate) \
		--disable-compizconfig \
		$(use_enable dbus) \
		$(use_enable dbus dbus-glib) \
		$(use_enable fuse) \
		--disable-gsettings \
		$(use_enable svg librsvg) \
		--disable-marco \
		$(use_enable mate) \
		--disable-gtk
}

src_install() {
	default
	prune_libtool_files --all

	# Install compiz-manager
	dobin "${FILESDIR}"/compiz-manager

	# Add the full-path to lspci
	sed -i "s#lspci#/usr/sbin/lspci#" "${D}/usr/bin/compiz-manager" || die

	# Fix the hardcoded lib paths
	sed -i "s#/lib/#/$(get_libdir)/#g" "${D}/usr/bin/compiz-manager" || die

	# Create gentoo's config file
	dodir /etc/xdg/compiz

	cat <<- EOF > "${D}/etc/xdg/compiz/compiz-manager"
	SKIP_CHECKS="yes"
	EOF

	dodir /etc/skel/.config/compiz/compizconfig

	cat <<- EOF > "${D}/etc/skel/.config/compiz/compizconfig/Default.ini"
	[core]
	as_active_plugins = core;workarounds;dbus;resize;crashhandler;mousepoll;decoration;svg;wall;place;png;text;imgjpeg;move;regex;animation;ezoom;switcher;
	s0_hsize = 2
	s0_vsize = 2

	EOF

	domenu "${FILESDIR}"/compiz.desktop
}
