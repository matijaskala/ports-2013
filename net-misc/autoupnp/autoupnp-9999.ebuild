# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/autoupnp/autoupnp-9999.ebuild,v 1.2 2013/10/16 12:23:59 mgorny Exp $

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="http://bitbucket.org/mgorny/${PN}.git"

inherit git-r3
#endif

inherit autotools-utils

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="https://bitbucket.org/mgorny/autoupnp/"
SRC_URI="mirror://bitbucket/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND="net-libs/miniupnpc:0=
	libnotify? ( x11-libs/libtinynotify:0= )"
DEPEND="${RDEPEND}"

#if LIVE
KEYWORDS=
SRC_URI=
#endif

src_configure() {
	myeconfargs=(
		$(use_with libnotify)
	)

	autotools-utils_src_configure
}
