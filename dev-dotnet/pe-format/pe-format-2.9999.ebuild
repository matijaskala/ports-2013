# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/pe-format/pe-format-2.9999.ebuild,v 1.4 2013/10/14 20:53:46 mgorny Exp $

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="http://bitbucket.org/mgorny/${PN}2.git"

inherit git-r3
#endif

inherit autotools-utils fdo-mime systemd

DESCRIPTION="Intelligent PE executable wrapper for binfmt_misc"
HOMEPAGE="https://bitbucket.org/mgorny/pe-format2/"
SRC_URI="mirror://bitbucket/mgorny/${PN}2/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="!<sys-apps/openrc-0.9.4"

#if LIVE
KEYWORDS=
SRC_URI=

DEPEND="sys-devel/systemd-m4"
#endif

src_configure() {
	local myeconfargs=(
		"$(systemd_with_unitdir)"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	keepdir /var/lib
}

pkg_postinst() {
	ebegin "Calling pe-format2-setup to update handler setup"
	pe-format2-setup
	eend ${?}

	fdo-mime_desktop_database_update
}
