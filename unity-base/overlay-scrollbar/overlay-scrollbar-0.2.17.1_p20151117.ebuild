# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils gnome2-utils

DESCRIPTION="Ayatana Scrollbars use an overlay to ensure scrollbars take up no active screen real-estate"
HOMEPAGE="http://launchpad.net/ayatana-scrollbar"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+16.04.}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="gnome-base/dconf
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${P/_p/+16.04.}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static \
		--disable-tests
}

src_install() {
	emake DESTDIR="${ED}" install || die

	rm -rf "${D}usr/etc" &> /dev/null
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe data/81overlay-scrollbar

	prune_libtool_files --modules
}

pkg_preinst() {
	gnome2_schemas_savelist
}
pkg_postinst() {
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_schemas_update
}
