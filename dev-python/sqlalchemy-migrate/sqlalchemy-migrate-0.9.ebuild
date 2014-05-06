# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sqlalchemy-migrate/sqlalchemy-migrate-0.9.ebuild,v 1.3 2014/05/04 16:17:11 maekke Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="SQLAlchemy Schema Migration Tools"
HOMEPAGE="http://code.google.com/p/sqlalchemy-migrate/ http://pypi.python.org/pypi/sqlalchemy-migrate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.5.21[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-0.7.8[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/tempita-0.4[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
# for tests: unittest2 and scripttest
