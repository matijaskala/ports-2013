# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/glib/glib-0.12.5.0-r1.ebuild,v 1.1 2013/12/12 06:03:43 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.5.9999

#nocabaldep is for the fancy cabal-detection feature at build-time
CABAL_FEATURES="lib profile haddock hoogle hscolour nocabaldep"
inherit haskell-cabal

DESCRIPTION="Binding to the GLIB library for Gtk2Hs."
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+closure_signals"

RDEPEND=">=dev-haskell/utf8-string-0.2:=[profile?] <dev-haskell/utf8-string-0.4:=[profile?]
	>=dev-lang/ghc-6.10.4:=
	dev-libs/glib:2
"
DEPEND="${RDEPEND}
	>=dev-haskell/gtk2hs-buildtools-0.12.5.1-r1:0=
	virtual/pkgconfig
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag closure_signals closure_signals)
}
