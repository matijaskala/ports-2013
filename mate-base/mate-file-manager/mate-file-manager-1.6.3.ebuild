# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit mate virtualx

DESCRIPTION="Caja file manager for the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="mate +introspection xmp"

RDEPEND=">=dev-libs/glib-2.28.0:2
	x11-libs/gtk+:2
	>=mate-base/mate-desktop-1.5.0
	>=x11-libs/pango-1.1.2
	x11-libs/gtk+:2[introspection?]
	>=gnome-base/gvfs-1.10.1[udisks]
	>=dev-libs/libxml2-2.4.7:2
	>=media-libs/libexif-0.5.12
	dev-libs/libunique:1
	x11-libs/libXext
	x11-libs/libXrender
	introspection? ( >=dev-libs/gobject-introspection-0.6.4 )
	xmp? ( media-libs/exempi:2 )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	sys-devel/gettext
	virtual/pkgconfig
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40.1
	>=mate-base/mate-common-1.2.2"
PDEPEND="mate? ( >=x11-themes/mate-icon-theme-1.2.0 )"

src_prepare() {
	gnome2_src_prepare

	# Remove -n
	sed -e 's:Exec=caja -n:Exec=caja:g' -i \
		data/caja.desktop || die
	# Remove crazy CFLAGS
	sed -i \
		-e 's:-DG.*DISABLE_DEPRECATED::g' \
		configure{,.ac} eel/Makefile.{am,in} || die
}

src_configure() {
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README THANKS TODO"

	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-packagekit \
		--enable-unique \
		--with-gtk=2.0 \
		$(use_enable introspection) \
		$(use_enable xmp)
}

src_test() {
	unset SESSION_MANAGER
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "Test phase failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "caja can use gstreamer to preview audio files. Just make sure"
	elog "to have the necessary plugins available to play the media type you"
	elog "want to preview"
}
