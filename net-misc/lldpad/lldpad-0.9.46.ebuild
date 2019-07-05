# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="Link Layer Discovery Protocol Implementation"
HOMEPAGE="https://www.open-lldp.org/"
SRC_URI="ftp://ftp-osl.osuosl.org/pub/open-lldp/open-lldp-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kernel_linux"
RESTRICT="mirror"

COMMON_DEPEND="dev-libs/libconfig
	dev-libs/libnl:1.1
"
DEPEND="${COMMON_DEPEND}
	sys-devel/flex
	virtual/pkgconfig
	kernel_linux? ( >=sys-kernel/linux-headers-2.6.29 )
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/iproute2
"

S="${WORKDIR}/open-lldp"

src_prepare() {
	sed -i -e '/AM_CFLAGS/ s/-Werror //' Makefile.am || die
	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install
	rm -r "${D}"/etc/bash_completion.d || die
	rm -r "${D}"etc/init.d || die
}
