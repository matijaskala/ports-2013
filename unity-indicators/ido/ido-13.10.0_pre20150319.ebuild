# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit autotools eutils flag-o-matic gnome2 vala

DESCRIPTION="Widgets and other objects used for indicators by the Unity desktop"
HOMEPAGE="https://launchpad.net/ido"
MY_PV="${PV/_pre/+15.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.37
	x11-libs/gtk+:3
	$(vala_depend)"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	append-cflags -Wno-error
	eautoreconf
}
