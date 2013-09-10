# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A collection of funtoo themes for splashutils."
HOMEPAGE=""
SRC_URI="http://splash-themes-funtoo.googlecode.com/files/fb-splash-theme-funtoo_purple.tar.bz2
		 http://splash-themes-funtoo.googlecode.com/files/fb-splash-theme-funtoo_blue.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=media-gfx/splashutils-1.1.9.5[png]"
RDEPEND="${DEPEND}"
RESTRICT="binchecks strip nomirror"

S="${WORKDIR}"

src_install() {
	dodir /etc/splash/
	cp -R "${WORKDIR}"/{funtoo_purple,funtoo_blue} "${D}/etc/splash"
}
