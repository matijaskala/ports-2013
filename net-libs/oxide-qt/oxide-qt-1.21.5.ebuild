# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils python-single-r1

DESCRIPTION="Web browser engine library for Qt"
HOMEPAGE="https://launchpad.net/oxide"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +plugins"
RESTRICT="mirror"

DEPEND="dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	dev-qt/qtcore:5=[debug?]
	dev-qt/qtgui:5[debug?]
	dev-qt/qtdbus:5[debug?]
	dev-qt/qtdeclarative:5[debug?]
	dev-qt/qtfeedback:5
	dev-qt/qtpositioning:5[debug?]
	dev-qt/qtnetwork:5[debug?]
	dev-qt/qttest:5[debug?]
	dev-util/ninja
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	sys-apps/dbus
	sys-libs/libcap
	virtual/libudev
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/pango"

export QT_SELECT=5
# Source expects build directory be located within source directory for relative paths to work correctly #
BUILD_DIR="${S}/${MY_P}_build"

pkg_pretend() {
	if use debug; then
		CHECKREQS_DISK_BUILD="17.5G"
	else
		CHECKREQS_DISK_BUILD="3G"
	fi
	check-reqs_pkg_setup
}

src_configure() {
	mycmakeargs+=( 	-DUSE_GN=1
			-DBOOTSTRAP_GN=1
			-DENABLE_PROPRIETARY_CODECS=1)
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		# prevent generate and dump debug symbols to save diskspace
		CMAKE_BUILD_TYPE="Release"
	fi
	use plugins && mycmakeargs+=(-DENABLE_PLUGINS=1)
	cmake-utils_src_configure
}
