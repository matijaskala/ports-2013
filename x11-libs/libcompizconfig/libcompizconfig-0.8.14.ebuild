# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Compiz Configuration System"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="dev-libs/libxml2
	dev-libs/protobuf
	>=x11-wm/compiz-${PV}
	x11-libs/libX11"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.41
	virtual/pkgconfig
	x11-base/xorg-proto"

RESTRICT="test"

src_configure() {
	econf \
		--enable-fast-install \
		--disable-static
}

src_install() {
	default
	prune_libtool_files --all
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
