# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-hcidump/bluez-hcidump-2.5.ebuild,v 1.3 2013/11/23 21:50:52 pacho Exp $

EAPI=5

DESCRIPTION="Bluetooth HCI packet analyzer"
HOMEPAGE="http://www.bluez.org/"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=net-wireless/bluez-4.98"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/xz-utils"
