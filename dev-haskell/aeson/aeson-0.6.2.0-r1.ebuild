# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/aeson/aeson-0.6.2.0-r1.ebuild,v 1.1 2013/09/13 09:00:30 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Fast JSON parsing and encoding"
HOMEPAGE="https://github.com/bos/aeson"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="developer"

RDEPEND=">=dev-haskell/attoparsec-0.8.6.1:=[profile?]
	>=dev-haskell/blaze-builder-0.2.1.4:=[profile?]
	dev-haskell/deepseq:=[profile?]
	>=dev-haskell/dlist-0.2:=[profile?]
	>=dev-haskell/hashable-1.1.2.0:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/syb:=[profile?]
	>=dev-haskell/text-0.11.1.0:=[profile?]
	>=dev-haskell/unordered-containers-0.1.3.0:=[profile?]
	>=dev-haskell/vector-0.7.1:=[profile?]
	>=dev-lang/ghc-6.12.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8.0.2
	test? ( dev-haskell/quickcheck
		dev-haskell/test-framework
		dev-haskell/test-framework-quickcheck2 )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag developer developer)
}
