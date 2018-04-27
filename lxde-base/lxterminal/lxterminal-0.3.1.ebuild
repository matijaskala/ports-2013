# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Lightweight vte-based tabbed terminal emulator for LXDE"
HOMEPAGE="https://wiki.lxde.org/en/LXTerminal"

if [[ ${PV} == *9999* ]]; then
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm ~arm64 ~mips ppc x86 ~amd64-linux ~arm-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk3"

RDEPEND="dev-libs/glib:2
	!gtk3? ( x11-libs/gtk+:2 x11-libs/vte:0 )
	gtk3?  ( x11-libs/gtk+:3 x11-libs/vte:2.91 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40.0"

DOCS=( AUTHORS NEWS )

src_configure() {
	econf --enable-man $(use_enable gtk3)
}
