# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit mate

DESCRIPTION="Tool to display MATE dialogs from the commandline and shell scripts"
HOMEPAGE="http://mate-desktop"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+compat gtk3 libnotify"

# /usr/bin/gdialog could collide with older GNOME2 zenity[compat]
RDEPEND="gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	>=dev-libs/glib-2.8:2
	compat? ( >=dev-lang/perl-5
			!<=gnome-extra/zenity-2.32.1[compat] )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.14
	virtual/pkgconfig
	>=app-text/mate-doc-utils-1.5.0
	>=mate-base/mate-common-1.5.0"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable libnotify)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"
}

src_install() {
	mate_src_install

	if ! use compat; then
		rm "${ED}/usr/bin/gdialog" || die "rm gdialog failed!"
	fi
}
