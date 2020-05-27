# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Compiz Fusion Window Decorator Plugins"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
RESTRICT="mirror"

RDEPEND="
	virtual/jpeg:0
	virtual/glu
	>=x11-libs/compiz-bcop-0.7.3
	<x11-libs/compiz-bcop-0.9
	>=x11-wm/compiz-0.8
	<x11-wm/compiz-0.9
	x11-libs/cairo[X]
	x11-libs/pango
"

DEPEND="${RDEPEND}"

BDEPEND="
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
