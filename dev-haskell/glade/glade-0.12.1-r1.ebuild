# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/glade/glade-0.12.1-r1.ebuild,v 1.2 2013/11/24 12:58:54 pacho Exp $

EAPI=5

# ebuild generated by hackport 0.3.2.9999

GTK_MAJ_VER="2"

#nocabaldep is for the fancy cabal-detection feature at build-time
CABAL_FEATURES="lib profile haddock hoogle hscolour nocabaldep"
inherit haskell-cabal

DESCRIPTION="Binding to the glade library."
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="${GTK_MAJ_VER}/${PV}"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="=dev-haskell/glib-0.12*:${GTK_MAJ_VER}=[profile?]
		=dev-haskell/gtk-0.12*:${GTK_MAJ_VER}=[profile?]
		>=dev-lang/ghc-6.10.4:=
		gnome-base/libglade:2.0"
DEPEND="${RDEPEND}
		dev-haskell/gtk2hs-buildtools:${GTK_MAJ_VER}
		virtual/pkgconfig"

src_prepare() {
	sed -e "s@gtk2hsTypeGen@gtk2hsTypeGen${GTK_MAJ_VER}@" \
		-e "s@gtk2hsHookGenerator@gtk2hsHookGenerator${GTK_MAJ_VER}@" \
		-e "s@gtk2hsC2hs@gtk2hsC2hs${GTK_MAJ_VER}@" \
		-i "${S}/Gtk2HsSetup.hs" \
		-i "${S}/SetupMain.hs" \
		|| die "Could not change Gtk2HsSetup.hs for GTK+ slot ${GTK_MAJ_VER}"
	sed -e "s@gtk2hsC2hs@gtk2hsC2hs${GTK_MAJ_VER}@" \
		-e "s@gtk2hsTypeGen@gtk2hsTypeGen${GTK_MAJ_VER}@" \
		-e "s@gtk2hsHookGenerator@gtk2hsHookGenerator${GTK_MAJ_VER}@" \
		-i "${S}/${PN}.cabal" \
		|| die "Could not change ${PN}.cabal for GTK+ slot ${GTK_MAJ_VER}"
}
