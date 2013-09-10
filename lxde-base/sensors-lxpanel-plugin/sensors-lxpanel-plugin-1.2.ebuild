# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2 eutils

DESCRIPTION="Display temperature/voltages/fan speeds on lxpanel through lm-sensors"
HOMEPAGE="http://danamlund.dk/sensors_lxpanel_plugin/"

EGIT_COMMIT="v1.2"
EGIT_REPO_URI="https://github.com/danamlund/sensors-lxpanel-plugin.git"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk"

DEPEND="
	lxde-base/lxpanel
	=dev-libs/glib-2*
	gtk? ( =x11-libs/gtk+-2* )
	>=sys-apps/lm_sensors-3.3.3-r2 
	lxde-base/menu-cache
"

RDEPEND="${DEPEND}"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/destdir.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
        dodoc ${F}/README
}

pkg_postinst() {
		elog 'Simply use the lxpanel "Add/Remove Panel Items"'
		elog "option to add lm-sensors Monitor to your panel"
}
