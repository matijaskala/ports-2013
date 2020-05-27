# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Compiz Reloaded (meta)"
HOMEPAGE="https://gitlab.com/compiz"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="boxmenu +ccsm emerald experimental +extra fusionicon manager simpleccsm"

RDEPEND="
	>=x11-wm/compiz-${PV}
	>=x11-plugins/compiz-plugins-main-${PV}
	experimental? ( >=x11-plugins/compiz-plugins-experimental-${PV} )
	extra? ( >=x11-plugins/compiz-plugins-extra-${PV} )
	boxmenu? ( >=x11-apps/compiz-boxmenu-1.1.12 )
	ccsm? ( >=x11-misc/ccsm-${PV} )
	emerald? ( >=x11-wm/emerald-${PV} )
	fusionicon? ( >=x11-apps/fusion-icon-0.2.4 )
	manager? ( >=x11-apps/compiz-manager-0.7.0 )
	simpleccsm? ( >=x11-misc/simple-ccsm-${PV} )
"
