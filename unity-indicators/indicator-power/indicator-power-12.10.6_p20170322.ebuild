# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="Indicator showing power state used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-power"
MY_PV="${PV/_p/+17.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="gnome-extra/gnome-power-manager"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.40
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	sys-power/upower
	unity-base/unity-settings-daemon"

S=${WORKDIR}
MAKEOPTS="-j1"

src_prepare() {
	eapply "${FILESDIR}/sandbox_violations_fix.diff"
	eapply "${FILESDIR}/disable-url-dispatcher.diff"
	cmake-utils_src_prepare
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
