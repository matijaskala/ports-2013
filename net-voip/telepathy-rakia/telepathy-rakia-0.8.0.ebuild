# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/telepathy-rakia/telepathy-rakia-0.8.0.ebuild,v 1.3 2013/12/08 19:36:21 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_{6,7} )

inherit python-single-r1

DESCRIPTION="A SIP connection manager for Telepathy based around the Sofia-SIP library"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE="test"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.30:2
	>=net-libs/sofia-sip-1.12.11
	>=net-libs/telepathy-glib-0.17.6
	>=sys-apps/dbus-0.60
"
RDEPEND="${COMMON_DEPEND}
	!net-voip/telepathy-sofiasip
"
# telepathy-rakia was formerly known as telepathy-sofiasip
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	test? ( dev-python/twisted-core )
"
# eautoreconf requires: gtk-doc-am

src_configure() {
	econf --disable-fatal-warnings
}
