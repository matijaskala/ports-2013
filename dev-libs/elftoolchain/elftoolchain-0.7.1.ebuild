# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="BSD licensed ELF toolchain"
HOMEPAGE="https://elftoolchain.sourceforge.net"
SRC_URI="mirror://sourceforge/elftoolchain/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!dev-libs/elfutils
	!dev-libs/libelf"
BDEPEND="sys-apps/lsb-release
	virtual/pmake"

src_compile() {
	bmake -C common || die
	bmake -C libelf || die
}

src_install() {
	bmake -C libelf DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" install
}
