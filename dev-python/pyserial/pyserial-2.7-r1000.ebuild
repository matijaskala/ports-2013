# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

DESCRIPTION="Python Serial Port Extension"
HOMEPAGE="http://pyserial.sourceforge.net/ http://sourceforge.net/projects/pyserial/ https://pypi.python.org/pypi/pyserial"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="serial"
