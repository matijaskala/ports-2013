# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit base check-reqs cmake-utils python-single-r1

DESCRIPTION="Web browser engine library for Qt"
HOMEPAGE="https://launchpad.net/oxide"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug +plugins"
RESTRICT="mirror"

DEPEND="dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	dev-qt/qtcore:5[debug?]
	dev-qt/qtgui:5[debug?]
	dev-qt/qtdbus:5[debug?]
	dev-qt/qtdeclarative:5[debug?]
	dev-qt/qtpositioning:5[debug?]
	dev-qt/qtnetwork:5[debug?]
	dev-qt/qttest:5[debug?]
	dev-util/ninja
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	sys-apps/dbus
	>=sys-devel/gcc-4.8
	sys-libs/libcap
	virtual/libudev
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/pango"

export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmake

pkg_pretend() {
	if use debug; then
		CHECKREQS_DISK_BUILD="17.5G"
	else
		CHECKREQS_DISK_BUILD="3G"
	fi

	check-reqs_pkg_setup
}

pkg_setup() {
	python-single-r1_pkg_setup
	if [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 8 ]] ); then
			die "${P} requires an active >=gcc-4.8, please consult the output of 'gcc-config -l'"
        fi
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DENABLE_PROPRIETARY_CODECS=1"

	if use plugins; then
		mycmakeargs="${mycmakeargs}
		    -DENABLE_PLUGINS=1"
	fi

	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		# prevent generate and dump debug symbols to save diskspace
		CMAKE_BUILD_TYPE="Release"
	fi

	cmake-utils_src_configure
}
