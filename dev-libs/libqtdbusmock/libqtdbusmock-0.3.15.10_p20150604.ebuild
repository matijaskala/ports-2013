# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils ubuntu-versionator

DESCRIPTION="Qt Bindings for python-dbusmock"
HOMEPAGE="https://launchpad.net/libqtdbustest"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-cpp/gmock
	dev-libs/libqtdbustest
	net-misc/networkmanager"

src_prepare() {
	# disable build of tests
	sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die
}
