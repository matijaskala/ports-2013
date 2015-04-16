# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils flag-o-matic ubuntu vala

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="https://launchpad.net/dbusmenu"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="debug gtk3 +introspection"	# We force building both GTK2, GTK3, and 'introspection', but keep these in IUSE for main portage tree ebuilds
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.35.4
	dev-libs/dbus-glib
	dev-libs/json-glib
	dev-libs/libxml2
	dev-util/gtk-doc
	sys-apps/dbus
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	dev-libs/gobject-introspection"

DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	virtual/pkgconfig
	$(vala_depend)"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	eautoreconf
}

src_configure() {
	append-flags -Wno-error #414323
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --enable-tests \
		--prefix=/usr \
		--enable-introspection \
		--disable-static \
		$(use_enable debug massivedebugging) \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --enable-tests \
		--prefix=/usr \
		--enable-introspection \
		--disable-static \
		$(use_enable debug massivedebugging) \
		--with-gtk=3 || die
	popd
}

src_test() { :; } #440192

src_compile() {
	# Build GTK2 support #
	pushd build-gtk2
		emake || die
	popd

	# Build GTK3 support #
	pushd build-gtk3
		emake || die
	popd
}

src_install() {
	# Install GTK3 support #
	pushd build-gtk3
		make -C libdbusmenu-glib DESTDIR="${D}" install || die
		make -C libdbusmenu-gtk DESTDIR="${D}" install || die
		make -C tools DESTDIR="${D}" install || die
		make -C docs/libdbusmenu-glib DESTDIR="${D}" install || die
		make -C docs/libdbusmenu-gtk DESTDIR="${D}" install || die
		make -C po DESTDIR="${D}" install || die
		make -C tests DESTDIR="${D}" install || die
	popd

	# Install GTK2 support #
	pushd build-gtk2
		make -C libdbusmenu-gtk DESTDIR="${D}" install || die
		make -C tests DESTDIR="${D}" install || die
	popd

	prune_libtool_files --modules
}
