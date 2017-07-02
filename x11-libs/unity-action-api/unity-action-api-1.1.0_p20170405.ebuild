# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Allow applications to export actions in various forms to the Unity Shell"
HOMEPAGE="https://launchpad.net/unity-action-api"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.04.}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND="dev-libs/glib
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	unity-base/hud"
RDEPEND="${DEPEND}"

export QT_SELECT=5
