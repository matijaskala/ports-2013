# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils gnome2-utils vala

DESCRIPTION="Date and Time Indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-datetime"
MY_PV="${PV/_p/+17.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+eds"
S=${WORKDIR}
RESTRICT="mirror"

COMMON_DEPEND="
	net-libs/libaccounts-glib
	dev-libs/libdbusmenu:=
	dev-libs/libtimezonemap:=
	gnome-extra/evolution-data-server:=
	media-libs/gstreamer:1.0
	net-misc/url-dispatcher
	sys-apps/util-linux
	unity-indicators/ido:=
	>=x11-libs/libnotify-0.7.6"
RDEPEND="${COMMON_DEPEND}
	unity-base/unity-control-center
	unity-base/unity-language-pack"
DEPEND="${COMMON_DEPEND}
	dev-libs/properties-cpp"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	# Fix schema errors and sandbox violations #
	epatch -p1 "${FILESDIR}/sandbox_violations_fix.diff"

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DVALA_COMPILER=$VALAC
		-DVAPI_GEN=$VAPIGEN
		-DCMAKE_INSTALL_FULL_LOCALEDIR=/usr/share/locale)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}

pkg_preinst() {
        gnome2_schemas_savelist
        gnome2_icon_savelist
}
pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
