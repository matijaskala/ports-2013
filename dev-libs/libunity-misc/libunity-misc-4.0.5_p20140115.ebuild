# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic

DESCRIPTION="Miscellaneous modules for the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-misc"
MY_PV=${PV/_p/+14.04.}
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/4.1.0"
KEYWORDS="amd64 x86"
IUSE="doc"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="x11-libs/gtk+:3
	x11-libs/libXfixes
	dev-util/gtk-doc-am
	dev-util/gtk-doc"

src_prepare() {
	default
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
