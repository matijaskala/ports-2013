# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit mate autotools

DESCRIPTION="A session daemon for MATE that makes it easy to manage your laptop or desktop system"
HOMEPAGE="http://mate-desktop.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+applet gnome-keyring man policykit test"

# FIXME: Interactive testsuite (upstream ? I'm so...pessimistic)
RESTRICT="test"

COMMON_DEPEND=">=dev-libs/glib-2.13.0:2
	x11-libs/gtk+:2
	gnome-keyring? ( >=gnome-base/gnome-keyring-3.0.0 )
	>=dev-libs/dbus-glib-0.71
	>=x11-libs/libnotify-0.7.0
	>=x11-libs/cairo-1
	>=media-libs/libcanberra-0.10[gtk]
	>=sys-power/upower-0.9.1
	>=dev-libs/libunique-1.1:1
	>=x11-apps/xrandr-1.3
	>=x11-proto/xproto-7.0.15
	x11-libs/libX11
	x11-libs/libXext
	applet? ( mate-base/mate-panel )"

RDEPEND="${COMMON_DEPEND}
	policykit? ( mate-extra/mate-polkit )"

DEPEND="${COMMON_DEPEND}
	x11-proto/randrproto
	sys-devel/gettext
	app-text/scrollkeeper
	app-text/docbook-xml-dtd:4.3
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	app-text/mate-doc-utils
	man? ( app-text/docbook-sgml-utils
			>=app-text/docbook-sgml-dtd-4.3 )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.6-libsecret.patch"

	eautoreconf
	mate_src_prepare

	if ! use man; then
	# This needs to be after eautoreconf to prevent problems like bug #356277
	# Remove the docbook2man rules here since it's not handled by a proper
	# parameter in configure.in.
	sed -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' -i man/Makefile.in \
		|| die "docbook sed failed"
	fi
}

src_configure() {
	DOCS="AUTHORS HACKING NEWS README TODO"

	mate_src_configure \
		--enable-unique \
		--with-gtk=2.0 \
		$(use_enable applet applets) \
		$(use_with gnome-keyring keyring) \
		$(use_enable test tests) \
		--enable-compile-warnings=minimum
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-launch Xemake check || die "Test phase failed"
}
