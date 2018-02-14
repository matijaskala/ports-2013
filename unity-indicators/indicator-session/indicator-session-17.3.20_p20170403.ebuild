# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="Indicator showing session management, status and user switching used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-session"
MY_PV="${PV/_p/+17.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+help"
S=${WORKDIR}
RESTRICT="mirror"

RDEPEND="
	app-admin/system-config-printer
	dev-cpp/gtest
	>=dev-libs/glib-2.36
	dev-libs/libappindicator:=
	dev-libs/libdbusmenu:=
	help? ( gnome-extra/yelp
		gnome-extra/gnome-user-docs )"
DEPEND="$RDEPEND"

src_prepare() {
	# Disable url-dispatcher when not using unity8-desktop-session
	eapply "${FILESDIR}/disable-url-dispatcher.diff"

	# Remove dependency on whoopsie (Ubuntu's error submission tracker)
	sed -e 's:libwhoopsie):):g' \
		-i CMakeLists.txt
	for each in $(grep -ri whoopsie | awk -F: '{print $1}'); do
		sed -e '/whoopsie/Id' -i "${each}"
	done

	# Fix sandbox violations #
	eapply "${FILESDIR}/sandbox_violations_fix-17.04.diff"

	if ! use help || has nodoc ${FEATURES}; then
		sed -n '/indicator.help/{s|^|//|};p' \
			-i src/service.c
	else
		sed -e 's:menu, help_label:menu, _("Unity Help"):g' \
			-i src/service.c
		sed -e 's:yelp:yelp help\:ubuntu-help:g' \
			-i src/backend-dbus/actions.c
	fi

	cmake-utils_src_prepare
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
