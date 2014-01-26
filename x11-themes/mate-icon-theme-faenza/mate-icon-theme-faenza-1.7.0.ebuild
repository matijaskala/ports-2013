# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit mate

DESCRIPTION="Faenza icon theme, that was adapted for MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( x11-themes/mate-icon-theme )
	x11-themes/hicolor-icon-theme"

RESTRICT="binchecks strip"
