# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal vala

DESCRIPTION="Widgets and other objects used for indicators by the Unity desktop"
HOMEPAGE="https://launchpad.net/ido"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.04.}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.37[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="$(vala_depend)"

src_prepare() {
	default
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	eautoreconf
}

multilib_src_configure() {
	append-cflags -Wno-error

	local ECONF_SOURCE=${S}
	econf
}
