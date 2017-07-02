# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="Content sharing/picking service to allow apps to exchange content"
HOMEPAGE="https://launchpad.net/content-hub"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.04.}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
S=${WORKDIR}
RESTRICT="mirror"

DEPEND="!dev-libs/libupstart-app-launch
	dev-libs/glib
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qttest:5
	dev-qt/qdoc:5
	dev-util/dbus-test-runner
	dev-util/lcov
	net-libs/ubuntu-download-manager:=
	dev-libs/ubuntu-app-launch
	sys-libs/libapparmor
	sys-libs/libnih[dbus]
	x11-libs/gsettings-qt
	x11-libs/libnotify
	x11-libs/ubuntu-ui-toolkit"

export QT_SELECT=5
export QT_DEBUG_PLUGINS=1	# Uncommented to debug the inevitable QML plugins problems
export QML_IMPORT_TRACE=1
unset QT_QPA_PLATFORMTHEME

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
