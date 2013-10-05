# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-monocle/lc-monocle-0.5.90-r2.ebuild,v 1.1 2013/10/02 09:49:30 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Monocle, the modular document viewer for LeechCraft."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+djvu debug +fb2 +pdf +spectre"

DEPEND="~app-leechcraft/lc-core-${PV}
	pdf? ( app-text/poppler[qt4] )
	djvu? ( app-text/djvu )
	spectre? (
		app-text/libspectre
		|| (
			app-text/poppler[-lcms]
			<app-text/ghostscript-gpl-9.07
		)
	)"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable djvu MONOCLE_SEEN)
		$(cmake-utils_use_enable fb2 MONOCLE_FXB)
		$(cmake-utils_use_enable pdf MONOCLE_PDF)
		$(cmake-utils_use_enable spectre MONOCLE_POSTRUS)"

	cmake-utils_src_configure
}
