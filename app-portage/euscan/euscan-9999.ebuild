# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/euscan/euscan-9999.ebuild,v 1.5 2013/10/15 11:10:55 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="xml"

inherit distutils-r1 git-2

DESCRIPTION="Ebuild upstream scan utility"
HOMEPAGE="http://euscan.iksaif.net"
SRC_URI=""
EGIT_REPO_URI="git://github.com/iksaif/euscan.git"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS=""

DEPEND="sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=app-portage/gentoolkit-0.2.8[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	virtual/python-argparse[${PYTHON_USEDEP}]"

python_prepare_all() {
	python_export_best
	echo VERSION="${PV}" "${PYTHON}" setup.py set_version
	VERSION="${PV}" "${PYTHON}" setup.py set_version
	distutils-r1_python_prepare_all
}
