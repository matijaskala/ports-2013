# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils ubuntu-versionator

DESCRIPTION="Miscellaneous modules for the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-misc"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/4.1.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="x11-libs/gtk+:3
	>=x11-libs/libXfixes-5.0a
	dev-util/gtk-doc-am
	dev-util/gtk-doc"

src_prepare() {
	epatch "${FILESDIR}/libunity-misc-4.0.5b-deprecated-api.patch"

	# Make docs optional #
	! use doc && \
		sed -e 's:unity-misc doc:unity-misc:' \
			-i Makefile.am
	eautoreconf
	append-cflags -Wno-error
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
