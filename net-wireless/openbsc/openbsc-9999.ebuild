# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/openbsc/openbsc-9999.ebuild,v 1.3 2014/04/26 12:40:33 zx2c4 Exp $

EAPI=5

inherit autotools git-2

DESCRIPTION="OpenBSC, OsmoSGSN, OsmoBSC and other programs"
HOMEPAGE="http://openbsc.osmocom.org/trac/wiki/OpenBSC"
EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
EGIT_BRANCH="jolly/testing"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	net-libs/libosmocore
	net-libs/libosmo-abis
	dev-db/libdbi"
RDEPEND="${DEPEND}
	dev-db/libdbi-drivers[sqlite]
	dev-db/sqlite:3"

S="${WORKDIR}/${P}/${PN}"
EGIT_SOURCEDIR="${WORKDIR}/${P}"

src_prepare() {
	eautoreconf
}
