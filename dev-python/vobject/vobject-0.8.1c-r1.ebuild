# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/vobject/vobject-0.8.1c-r1.ebuild,v 1.3 2013/06/25 12:51:12 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy2_0 )

inherit distutils-r1

DESCRIPTION="A full featured Python package for parsing and generating vCard and vCalendar files"
HOMEPAGE="http://vobject.skyhouseconsulting.com/ http://pypi.python.org/pypi/vobject"
SRC_URI="http://vobject.skyhouseconsulting.com/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/setuptools"[${PYTHON_USEDEP}]
DEPEND="${RDEPEND}"

DOCS=( ACKNOWLEDGEMENTS.txt )

python_test() {
	"${PYTHON}" test_vobject.py || die "Testing failed under ${EPYTHON}"
}
