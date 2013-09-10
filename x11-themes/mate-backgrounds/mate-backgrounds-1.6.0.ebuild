# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit mate

DESCRIPTION="A set of backgrounds packaged with the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"
