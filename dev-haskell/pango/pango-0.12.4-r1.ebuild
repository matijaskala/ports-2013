# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/pango/pango-0.12.4-r1.ebuild,v 1.3 2013/12/07 19:31:37 pacho Exp $

EAPI=5

# ebuild generated by hackport 0.3.9999

GTK_MAJ_VER="2"

#nocabaldep is for the fancy cabal-detection feature at build-time
CABAL_FEATURES="lib profile haddock hoogle hscolour nocabaldep"
inherit haskell-cabal

DESCRIPTION="Binding to the Pango text rendering engine."
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="${GTK_MAJ_VER}/${PV}"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=dev-haskell/cairo-0.12.0:${GTK_MAJ_VER}=[profile?]
		<dev-haskell/cairo-0.13:${GTK_MAJ_VER}=[profile?]
		>=dev-haskell/glib-0.12.0:${GTK_MAJ_VER}=[profile?]
		<dev-haskell/glib-0.13:${GTK_MAJ_VER}=[profile?]
		dev-haskell/mtl:=[profile?]
		>=dev-lang/ghc-6.10.4:=
		x11-libs/cairo
		x11-libs/pango"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		>=dev-haskell/gtk2hs-buildtools-0.12.4:${GTK_MAJ_VER}=
		virtual/pkgconfig"

src_prepare() {
	sed -e "s@gtk2hsTypeGen@gtk2hsTypeGen${GTK_MAJ_VER}@" \
		-e "s@gtk2hsHookGenerator@gtk2hsHookGenerator${GTK_MAJ_VER}@" \
		-e "s@gtk2hsC2hs@gtk2hsC2hs${GTK_MAJ_VER}@" \
		-i "${S}/Gtk2HsSetup.hs" \
		|| die "Could not change Gtk2HsSetup.hs for GTK+ slot ${GTK_MAJ_VER}"
	sed -e "s@gtk2hsC2hs@gtk2hsC2hs${GTK_MAJ_VER}@" \
		-e "s@gtk2hsTypeGen@gtk2hsTypeGen${GTK_MAJ_VER}@" \
		-e "s@gtk2hsHookGenerator@gtk2hsHookGenerator${GTK_MAJ_VER}@" \
		-i "${S}/${PN}.cabal" \
		|| die "Could not change ${PN}.cabal for GTK+ slot ${GTK_MAJ_VER}"
}
