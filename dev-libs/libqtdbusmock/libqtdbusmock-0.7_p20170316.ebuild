# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Qt Bindings for python-dbusmock"
HOMEPAGE="https://launchpad.net/libqtdbustest"
MY_PV="${PV/_p/+17.04.}.1"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
S=${WORKDIR}
RESTRICT="mirror"

DEPEND="
	dev-libs/libqtdbustest
	net-misc/networkmanager"
RDEPEND="${DEPEND}"

src_prepare() {
	# Include missing glib-2.0 header files for building with >=networkmanager-1.0.6 #
	sed -e 's:NetworkManager REQUIRED:NetworkManager REQUIRED glib-2.0 REQUIRED:g' \
		-i CMakeLists.txt

	# Disable build of tests #
	sed '/add_subdirectory(tests)/d' -i CMakeLists.txt || die
	cmake-utils_src_prepare
}
