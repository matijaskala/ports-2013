# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kdeartwork"
KDE_AUTODEPS="false"
inherit kde5

DESCRIPTION="KDE extra colorschemes"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-kf5-port.patch" )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE
		-DBUILD_ColorSchemes=TRUE
	)

	kde5_src_configure
}
