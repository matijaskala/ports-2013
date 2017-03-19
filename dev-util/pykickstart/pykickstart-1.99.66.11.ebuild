# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="pykickstart is a python library that is used for reading and writing kickstart files."
MY_PV=r${PV}-1
MY_P=${PN}-${MY_PV}
HOMEPAGE="http://fedoraproject.org/wiki/Pykickstart"
SRC_URI="https://github.com/rhinstaller/pykickstart/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
RESTRICT="mirror"
S=${WORKDIR}/${MY_P}

DEPEND="app-i18n/transifex-client
	sys-devel/gettext"
RDEPEND="${DEPEND}"
