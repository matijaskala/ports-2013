# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit mate

DESCRIPTION="Caja plugin for opening terminals"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=mate-base/mate-file-manager-1.2.2"

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	# Tarball has no proper build system, should be fixed on next release.
	mate_gen_build_system

	gnome2_src_prepare
}
