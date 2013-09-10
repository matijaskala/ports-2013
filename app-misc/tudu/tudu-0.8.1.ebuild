# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Command line interface to manage hierarchical todos"
HOMEPAGE="http://www.cauterized.net/~meskio/tudu/"
SRC_URI="http://cauterized.net/~meskio/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~*"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND=${DEPEND}

src_compile() {
	emake DESTDIR="/usr/" ETC_DIR="/etc" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}/" ETC_DIR="${D}/etc" install || die "install failed"
	dodoc AUTHORS README ChangeLog  || die
}
