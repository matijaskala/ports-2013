# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VALA_MIN_API_VERSION="0.22"
VALA_MAX_API_VERSION="0.22"

inherit cmake-utils gnome2-utils ubuntu vala

DESCRIPTION="Date and Time Indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-datetime"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	dev-libs/libtimezonemap:=
	unity-base/unity-language-pack
	unity-indicators/ido:="
DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	dev-libs/libtimezonemap
	dev-libs/properties-cpp
	>=gnome-extra/evolution-data-server-3.8
	net-misc/url-dispatcher
	unity-indicators/ido
	unity-base/unity-control-center
	>=x11-libs/libnotify-0.7.6"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	# Fix schema errors and sandbox violations #
	epatch -p1 "${FILESDIR}/sandbox_violations_fix.diff"

	# Make indicator-datetime compatiable with systemd's timezone changes #
	epatch -p1 "${FILESDIR}/get-timezone-from-systemd-timedatectl-14.10.diff"
	epatch -p1 "${FILESDIR}/systemd-timezone-nullptr-check.diff"

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	# Make indicator start using XDG autostart #
	sed -e '/NotShowIn=/d' \
		-i data/indicator-datetime.desktop.in
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DVALA_COMPILER=$VALAC
		-DVAPI_GEN=$VAPIGEN"
	cmake-utils_src_configure
}

pkg_preinst() {
        gnome2_schemas_savelist
        gnome2_icon_savelist
}

src_install() {
	cmake-utils_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Remove upstart jobs as we use XDG autostart desktop files to spawn indicators #
	rm -rf "${ED}usr/share/upstart"
}

pkg_postinst() {
        gnome2_schemas_update
        gnome2_icon_cache_update
}

pkg_postrm() {
        gnome2_schemas_update
        gnome2_icon_cache_update
}
