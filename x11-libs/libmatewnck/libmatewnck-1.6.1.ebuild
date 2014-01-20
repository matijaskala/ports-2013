# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit mate

DESCRIPTION="A window navigation construction kit for MATE"
HOMEPAGE="http://www.mate-desktop.org/"

LICENSE="LGPL-2"
SLOT="1"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="+introspection startup-notification"

RDEPEND="x11-libs/gtk+:2[introspection?]
	>=dev-libs/glib-2.16:2
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	introspection? ( >=dev-libs/gobject-introspection-0.6.14 )
	startup-notification? ( >=x11-libs/startup-notification-0.4 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	>=mate-base/mate-common-1.5.0"

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	gnome2_src_configure \
		$(use_enable introspection) \
		$(use_enable startup-notification)
}
