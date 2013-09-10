# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Adjust auto-parking of drive head in Western Digital hard disks"
HOMEPAGE="http://idle3-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
RESTRICT="mirror strip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_install() {
	dosbin idle3ctl || die
	doman idle3ctl.8 || die
}
