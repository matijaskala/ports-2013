# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic gnome2-utils

DESCRIPTION="Indicator for application menus"
HOMEPAGE="https://launchpad.net/indicator-appmenu"
MY_PV="${PV/_p/+16.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	dev-libs/libappindicator:3=
	x11-libs/bamf:=
	x11-libs/gtk+:3
	x11-libs/libwnck:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eapply_user
	eautoreconf
	append-cflags -Wno-error
}
