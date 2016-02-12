# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools eutils

DESCRIPTION="LightDM Webkit Greeter"
HOMEPAGE="http://launchpad.net/lightdm-webkit-greeter"
SRC_URI="http://launchpad.net/lightdm-webkit-greeter/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+gtk3"
RESTRICT="mirror"

DEPEND="gtk3? (net-libs/webkit-gtk:3)
	!gtk3? (net-libs/webkit-gtk:2)
	x11-misc/lightdm"
RDEPEND="${DEPEND}"

src_prepare() {
	use gtk3 || ( epatch "${FILESDIR}"/gtk2.patch ; eautoconf )
}
