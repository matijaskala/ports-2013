# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/zlib-conduit/zlib-conduit-1.0.0.ebuild,v 1.2 2013/11/05 11:40:57 chainsaw Exp $

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Streaming compression/decompression via conduits."
HOMEPAGE="http://github.com/snoyberg/conduit"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~x86"
IUSE="+debug"

RDEPEND="=dev-haskell/conduit-1.0*:=[profile?]
		>=dev-haskell/transformers-0.2.2:=[profile?]
		<dev-haskell/transformers-0.4:=[profile?]
		dev-haskell/void:=[profile?]
		=dev-haskell/zlib-bindings-0.1*:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? ( >=dev-haskell/hspec-1.3
			dev-haskell/quickcheck
			dev-haskell/resourcet
		)"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag debug debug)
}
