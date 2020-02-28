# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/rhinstaller/python-meh"
EGIT_COMMIT="r${PV}-1"
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 git-r3

DESCRIPTION="Python exception handling library"
HOMEPAGE="https://github.com/rhinstaller/python-meh"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

COMMON_DEPEND="
	dev-python/dbus-python
	dev-util/intltool
	sys-devel/gettext
	"
DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}
	dev-libs/newt
	gtk? (
		x11-libs/gtk+:3
		dev-python/pygobject:3
	)
	>=dev-libs/libreport-2.0.18
	net-misc/openssh"
