# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils ubuntu

DESCRIPTION="Simple convenience library for handling properties and signals in C++11"
HOMEPAGE="https://launchpad.net/properties-cpp"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="test? ( dev-cpp/gtest )
	dev-libs/boost
	>=sys-devel/gcc-4.8"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	if [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 8 ]] ); then
			die "${P} requires an active >=gcc-4.8, please consult the output of 'gcc-config -l'"
	fi
}

