# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

URELEASE="wily"
inherit autotools eutils gnome2

DESCRIPTION="GTK+3 timezone map widget used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libtimezonemap"
MY_PV="${PV/_pre/+15.04.}.2"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1.0.0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	net-libs/libsoup
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3"

src_prepare() {
	eautoreconf
}
