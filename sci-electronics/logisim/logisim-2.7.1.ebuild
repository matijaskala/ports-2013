# Distributed under the terms of the GNU General Public License v2

inherit eutils java-pkg-2

DESCRIPTION="An educational tool for designing and simulating digital logic circuits."
HOMEPAGE="http://ozark.hendrix.edu/~burch/logisim/"
SRC_URI="mirror://sourceforge/circuit/2.7.x/${PV}/${PN}-generic-${PV}.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND="${RDEPEND}"

src_install(){
        java-pkg_newjar "${DISTDIR}"/${A}
        java-pkg_dolauncher ${PN}
        make_desktop_entry ${PN} Logisim /usr/share/${PN}/${PN}.png Education
}
