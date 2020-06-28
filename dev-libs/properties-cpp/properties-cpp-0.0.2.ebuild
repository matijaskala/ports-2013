# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A very simple convenience library for handling properties and signals in C++11"
HOMEPAGE="https://launchpad.net/properties-cpp"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/${PN}/0.0.2-3/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

src_prepare() {
	sed -i '/add_subdirectory(tests)/d' CMakeLists.txt || die
	cmake_src_prepare
}
