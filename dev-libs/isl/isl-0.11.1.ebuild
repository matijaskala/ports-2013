# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/isl/isl-0.11.1.ebuild,v 1.8 2013/11/04 02:27:01 mattst88 Exp $

EAPI=4
inherit eutils

DESCRIPTION="A library for manipulating integer points bounded by affine constraints"
HOMEPAGE="http://www.kotnet.org/~skimo/isl/"
SRC_URI="http://www.kotnet.org/~skimo/isl/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

RDEPEND="dev-libs/gmp"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog AUTHORS doc/manual.pdf )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.07-gdb-autoload-dir.patch

	# m4/ax_create_pkgconfig_info.m4 is broken but avoid eautoreconf
	# http://groups.google.com/group/isl-development/t/37ad876557e50f2c
	sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die #382737
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
