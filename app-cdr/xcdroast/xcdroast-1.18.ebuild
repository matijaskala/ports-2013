# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils

DESCRIPTION="Lightweight cdrtools front-end for CD and DVD writing"
HOMEPAGE="http://www.xcdroast.org/"
SRC_URI="mirror://sourceforge/xcdroast/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2
	app-cdr/cdrtools"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/${P/_/}

PATCHES=( "${FILESDIR}"/makefile_destdir.patch )

src_configure() {
	econf \
		$(use_enable nls)
}

src_install() {
	default
	dodoc -r doc/*

	make_desktop_entry xcdroast "X-CD-Roast" "${EPREFIX}/usr/lib/${PN}/icons/xcdrlogo_icon.png"

	mv "${ED}"/usr/share/applications/{${PN}-,}${PN}.desktop || die
	rmdir "${ED}"/etc || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
