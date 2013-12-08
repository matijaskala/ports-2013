# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hashtables/hashtables-1.1.2.1.ebuild,v 1.3 2013/12/07 19:27:45 pacho Exp $

EAPI=5

# ebuild generated by hackport 0.3.4.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Mutable hash tables in the ST monad"
HOMEPAGE="http://github.com/gregorycollins/hashtables"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="bounds-checking debug portable sse4_1 +unsafe-tricks"

RDEPEND="dev-haskell/primitive:=[profile?]
	>=dev-haskell/vector-0.7:=[profile?] <dev-haskell/vector-0.12:=[profile?]
	>=dev-lang/ghc-6.10.4:=
	|| ( ( >=dev-haskell/hashable-1.1:=[profile?] <dev-haskell/hashable-1.2:=[profile?] )
		( >=dev-haskell/hashable-1.2.1:=[profile?] <dev-haskell/hashable-1.3:=[profile?] ) )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag bounds-checking bounds-checking) \
		$(cabal_flag debug debug) \
		$(cabal_flag portable portable) \
		$(cabal_flag sse4_1 sse41) \
		$(cabal_flag unsafe-tricks unsafe-tricks)
}
