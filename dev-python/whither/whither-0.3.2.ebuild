# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 )
inherit distutils-r1

DESCRIPTION="Universal Linux Application SDK"
HOMEPAGE="https://github.com/Antergos/whither"
SRC_URI="https://github.com/Antergos/whither/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="${DEPEND}
	dev-python/PyQt5[webengine]
	dev-python/pygobject:3
	x11-libs/gtk+:3"
