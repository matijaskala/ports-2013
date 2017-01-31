# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils flag-o-matic vala

DESCRIPTION="Widgets and other objects used for indicators by the Unity desktop"
HOMEPAGE="https://launchpad.net/ido"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.04.}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.37
	x11-libs/gtk+:3
	$(vala_depend)"

src_prepare() {
	eapply_user
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	append-cflags -Wno-error
	eautoreconf
}
