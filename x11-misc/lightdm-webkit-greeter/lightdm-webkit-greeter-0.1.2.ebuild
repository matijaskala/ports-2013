# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="LightDM Webkit Greeter"
HOMEPAGE="http://launchpad.net/lightdm-webkit-greeter"
SRC_URI="http://launchpad.net/lightdm-webkit-greeter/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="*"

DEPEND="net-libs/webkit-gtk:2
	>=x11-misc/lightdm-1.0.0"
RDEPEND="${DEPEND}"