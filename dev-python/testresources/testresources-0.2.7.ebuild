# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/testresources/testresources-0.2.7.ebuild,v 1.1 2013/09/17 17:16:44 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Testresources, a pyunit extension for managing expensive test resources."
HOMEPAGE="https://launchpad.net/testresources"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/nose[${PYTHON_USEDEP}]
				dev-python/testtools[${PYTHON_USEDEP}]
				dev-python/fixtures[${PYTHON_USEDEP}]
				virtual/python-unittest2[${PYTHON_USEDEP}] )"
RDEPEND=""

python_test() {
	"${PYTHON}" setup.py nosetests || die
}
