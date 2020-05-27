# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Compiz Configuration System"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="https://github.com/compiz-reloaded/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="dev-libs/libxml2
	dev-libs/protobuf
	>=x11-wm/compiz-${PV}
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND=">=dev-util/intltool-0.41
	virtual/pkgconfig"

RESTRICT="test"

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
	echo > "${D}/etc/compizconfig/config" << EOF
[gnome_session]
backend = gconf
integration = true
plugin_list_autosort = true
profile = Minimal

[general]
backend = ini
plugin_list_autosort = true
profile = Minimal

EOF
}
