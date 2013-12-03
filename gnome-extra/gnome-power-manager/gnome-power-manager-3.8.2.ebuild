# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-power-manager/gnome-power-manager-3.8.2.ebuild,v 1.2 2013/11/30 19:20:37 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2 virtualx

DESCRIPTION="GNOME power management service"
HOMEPAGE="http://projects.gnome.org/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

COMMON_DEPEND="
	>=dev-libs/glib-2.31.10:2
	>=x11-libs/gtk+-3.3.8:3
	>=x11-libs/cairo-1
	>=sys-power/upower-0.9.1
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	>=app-text/gnome-doc-utils-0.3.2
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
	sys-devel/gettext
	x11-proto/randrproto
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

# docbook-sgml-utils and docbook-sgml-dtd-4.1 used for creating man pages
# (files under ${S}/man).
# docbook-xml-dtd-4.4 and -4.1.2 are used by the xml files under ${S}/docs.

src_prepare() {
	# Drop debugger CFLAGS from configure
	# Touch configure.ac only if running eautoreconf, otherwise
	# maintainer mode gets triggered -- even if the order is correct
	sed -e 's:^CPPFLAGS="$CPPFLAGS -g"$::g' \
		-i configure || die "debugger sed failed"
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable test tests) \
		--enable-compile-warnings=minimum
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}
