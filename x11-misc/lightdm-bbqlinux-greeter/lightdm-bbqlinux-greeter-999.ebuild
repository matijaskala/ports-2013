# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit git-2

DESCRIPTION="LightDM BBQLinux Greeter"
HOMEPAGE=""
EGIT_REPO_URI="https://www.github.com/bbqlinux/${PN}.git"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="+gtk2"

DEPEND="x11-libs/gtk+
	>=x11-misc/lightdm-1.2.2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/src

src_configure() {
	econf $(use_with gtk2)
}
