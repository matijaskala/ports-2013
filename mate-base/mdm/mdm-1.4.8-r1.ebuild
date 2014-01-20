# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit mate

MINT_V="petra"
DESCRIPTION="Mate Display Manager"
HOMEPAGE="http://mate-desktop.org"
SRC_URI="http://packages.linuxmint.com/pool/main/m/mdm/${PN}_${PV}+${MINT_V}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="net-libs/webkit-gtk:2
	gnome-base/libgnomecanvas"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}+${MINT_V}

src_prepare() {
	autotools_run_tool gnome-doc-prepare --copy --force || die
	mate_src_prepare
}
