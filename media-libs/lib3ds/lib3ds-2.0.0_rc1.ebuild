# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/lib3ds/lib3ds-2.0.0_rc1.ebuild,v 1.6 2013/09/22 12:45:27 ago Exp $

EAPI=5
MY_PV="20080909"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="library for managing 3D-Studio Release 3 and 4 .3DS files"
HOMEPAGE="http://code.google.com/p/lib3ds/"
SRC_URI="http://lib3ds.googlecode.com/files/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

S=${WORKDIR}/${MY_P}

RDEPEND="media-libs/freeglut
	virtual/opengl"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README
}
