# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Extra CMake utility modules"
HOMEPAGE="https://launchpad.net/cmake-extras"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.04.}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}"
