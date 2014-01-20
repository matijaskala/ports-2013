# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit mate multilib

DESCRIPTION="Libraries for the MATE desktop that are not part of the UI"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3"

# Upstream says to use glib 2.34 so as to not have to rebuild once someone
# moves to 2.34 - see mailing list for more info:
# http://ml.mate-desktop.org/pipermail/mate-dev/2012-November/000009.html
RDEPEND=">=dev-libs/glib-2.34:2
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	dev-libs/libunique:1
	>=x11-libs/libXrandr-1.2
	>=x11-libs/startup-notification-0.5"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	app-text/yelp-tools
	~app-text/docbook-xml-dtd-4.1.2
	x11-proto/xproto
	>=x11-proto/randrproto-1.2"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

src_prepare() {
	# *Very* dirty hack so it installs, fixed in next release 
	touch "${S}/tools/mate-conf-import" || die
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	#Disable desktop doc due to file collision
	G2CONF="${G2CONF}
		--enable-mate-conf-import
		--disable-desktop-docs"

	use gtk3 && G2CONF="${G2CONF} --with-gtk=3.0"
	use !gtk3 && G2CONF="${G2CONF} --with-gtk=2.0"
	gnome2_src_configure
}

src_install() {
	gnome2_src_install
	# Do migrate script fu see url:
	# https://github.com/Sabayon/mate-overlay/issues/38
	rm "${D}"/usr/share/applications/mate-conf-import.desktop || die "rm failed"
	mkdir "${D}"/usr/$(get_libdir)/mate-desktop || die "mkdir failed"
	mv "${D}"/usr/bin/mate-conf-import \
		"${D}"/usr/$(get_libdir)/mate-desktop/ || die "mv failed"
}
