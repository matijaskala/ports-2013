# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_AUTOMAKE='1.14'
inherit autotools eutils

DESCRIPTION="Library parsing abiword documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libabw"
SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc static-libs"

RDEPEND="
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	epatch "${FILESDIR}/${P}-dereference-before-null-check.patch"
	epatch "${FILESDIR}/${P}-do-not-let-AbiDocument_parse-throw.patch"
	epatch "${FILESDIR}/${P}-boost-1.59.patch"
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-werror \
		$(use_enable static-libs static) \
		$(use_with doc docs)
}

src_install() {
	default
	prune_libtool_files --all
}
