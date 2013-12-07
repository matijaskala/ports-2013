# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pax-utils/pax-utils-0.7.ebuild,v 1.7 2013/12/07 09:54:51 pacho Exp $

EAPI=4

inherit eutils toolchain-funcs unpacker

DESCRIPTION="ELF related utils for ELF 32/64 binaries that can check files for security relevant properties"
HOMEPAGE="http://hardened.gentoo.org/pax-utils.xml"
SRC_URI="mirror://gentoo/pax-utils-${PV}.tar.xz
	http://dev.gentoo.org/~solar/pax/pax-utils-${PV}.tar.xz
	http://dev.gentoo.org/~vapier/dist/pax-utils-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="caps python"
#RESTRICT="mirror"

RDEPEND="caps? ( sys-libs/libcap )
	python? ( dev-python/pyelftools )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

_emake() {
	emake \
		USE_CAP=$(usex caps) \
		USE_PYTHON=$(usex python) \
		"$@"
}

src_compile() {
	_emake CC="$(tc-getCC)"
}

src_test() {
	_emake check
}

src_install() {
	_emake DESTDIR="${ED}" PKGDOCDIR='$(DOCDIR)'/${PF} install
}
