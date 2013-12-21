# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"

inherit mate

DESCRIPTION="Caja extension for sending files to locations"
HOMEPAGE="http://www.mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cdr gajim +mail pidgin upnp"

RDEPEND=">=x11-libs/gtk+-2.18:2
	>=dev-libs/glib-2.25.9:2
	>=mate-base/mate-file-manager-1.2.2
	cdr? ( >=app-cdr/brasero-2.32.1 )
	gajim? (
		net-im/gajim
		>=dev-libs/dbus-glib-0.60 )
	pidgin? ( >=dev-libs/dbus-glib-0.60 )
	upnp? ( >=net-libs/gupnp-0.13.0 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	>=mate-base/mate-common-1.2.2"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	local myconf
	myconf="--with-plugins=removable-devices,"
	use cdr && myconf="${myconf}caja-burn,"
	use mail && myconf="${myconf}emailclient,"
	use pidgin && myconf="${myconf}pidgin,"
	use gajim && myconf="${myconf}gajim,"
	use upnp && myconf="${myconf}upnp,"

	mate_src_configure ${myconf}
}
