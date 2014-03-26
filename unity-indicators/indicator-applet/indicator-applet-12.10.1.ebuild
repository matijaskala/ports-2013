# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils launchpad

DESCRIPTION="A small applet to display information from various applications consistently in the panel"
HOMEPAGE="https://launchpad.net/indicator-applet"

LICENSE="LGPL-2.1 LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libindicator:3
	x11-libs/gtk+:3
	>=gnome-base/gnome-panel-3.6"

src_prepare() {
	# "Only <glib.h> can be included directly." #
	sed -e "s:glib/gtypes.h:glib.h:g" \
		-i src/tomboykeybinder.h
	sed -i s/DISABLE_DEPRECATED/ENABLE_DEPRECATED/ src/Makefile.am
	eautoreconf
}
