# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/crypto-pubkey/crypto-pubkey-0.2.3.ebuild,v 1.1 2013/12/11 05:53:37 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Public Key cryptography"
HOMEPAGE="http://github.com/vincenthz/hs-crypto-pubkey"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="benchmark"

RDEPEND="dev-haskell/byteable:=[profile?]
	>=dev-haskell/crypto-numbers-0.2.2:=[profile?]
	>=dev-haskell/crypto-pubkey-types-0.4.1:=[profile?] <dev-haskell/crypto-pubkey-types-0.5:=[profile?]
	>=dev-haskell/crypto-random-0.0:=[profile?] <dev-haskell/crypto-random-0.1:=[profile?]
	>=dev-haskell/cryptohash-0.9.1:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( dev-haskell/hunit
		>=dev-haskell/quickcheck-2
		>=dev-haskell/test-framework-0.3.3
		dev-haskell/test-framework-hunit
		>=dev-haskell/test-framework-quickcheck2-0.2.9 )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag benchmark benchmark)
}
