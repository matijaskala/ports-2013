# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="CMake utility modules needed for building Vala Panel"
HOMEPAGE="https://gitlib.com/vala-panel-project/cmake-vala"
SRC_URI="https://launchpadlibrarian.net/435707633/cmake-vala_${PV}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-r${PV}"
