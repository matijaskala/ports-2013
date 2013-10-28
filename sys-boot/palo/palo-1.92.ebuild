# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/palo/palo-1.92.ebuild,v 1.2 2013/10/21 15:17:22 jer Exp $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="PALO : PArisc Linux Loader"
HOMEPAGE="http://parisc-linux.org/"
SRC_URI="http://dev.gentoo.org/~jer/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~hppa"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-9999-toolchain.patch
	sed -i palo/Makefile -e '/^LDFLAGS=/d' || die
}

src_compile() {
	local target
	for target in '-C palo' '-C ipl' 'MACHINE=parisc iplboot'; do
		emake AR=$(tc-getAR) CC=$(tc-getCC) LD=$(tc-getLD) ${target}
	done
}

src_install() {
	into /
	dosbin palo/palo

	doman palo.8
	dohtml README.html
	dodoc Changes TODO debian/changelog

	insinto /etc
	doins "${FILESDIR}"/palo.conf

	insinto /usr/share/palo
	doins iplboot

	insinto /etc/kernel/postinst.d/
	INSOPTIONS="-m 0744" doins "${FILESDIR}"/99palo
}
