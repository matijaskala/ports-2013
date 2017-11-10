# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2 vala

DESCRIPTION="A slick-looking LightDM greeter"
HOMEPAGE="https://github.com/linuxmint/slick-greeter"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="media-libs/freetype:2
	media-libs/libcanberra
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pixman
	x11-misc/lightdm[vala(-)]
	$(vala_depend)"
DEPEND="${RDEPEND}
	dev-util/intltool"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}
