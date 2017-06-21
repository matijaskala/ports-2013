# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Compiz Reloaded (meta)"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="+ccsm emerald experimental +extra fusionicon simpleccsm"

RDEPEND="
	>=x11-wm/compiz-${PV}
	>=x11-plugins/compiz-plugins-main-${PV}
	experimental? ( >=x11-plugins/compiz-plugins-experimental-${PV} )
	extra? ( >=x11-plugins/compiz-plugins-extra-${PV} )
	ccsm? ( >=x11-misc/ccsm-${PV} )
	emerald? ( >=x11-wm/emerald-${PV} )
	fusionicon? ( >=x11-apps/fusion-icon-0.2.4 )
	simpleccsm? ( >=x11-misc/simple-ccsm-${PV} )
"
