# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-tpi/lc-tpi-0.6.0.ebuild,v 1.1 2013/09/24 15:53:20 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Task progress indicator quark for LeechCraft"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4
	~virtual/leechcraft-quark-sideprovider-${PV}"
RDEPEND="${DEPEND}"
