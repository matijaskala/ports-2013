# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.26
VALA_USE_DEPEND=vapigen

inherit gnome2 vala

DESCRIPTION="The simplest dock on the planet"
HOMEPAGE="https://launchpad.net/plank"
SRC_URI="https://launchpad.net/${PN}/1.0/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libdbusmenu[gtk3]
	dev-libs/libgee:0.8
	x11-libs/bamf
	x11-libs/gtk+:3[X]"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	gnome-base/gnome-common
	sys-devel/gettext"

DOCS=( AUTHORS COPYING COPYRIGHT NEWS README )

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}
