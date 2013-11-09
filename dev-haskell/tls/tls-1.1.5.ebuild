# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/tls/tls-1.1.5.ebuild,v 1.2 2013/11/05 11:38:14 chainsaw Exp $

EAPI=5

# ebuild generated by hackport 0.3.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="TLS/SSL protocol native implementation (Server and Client)"
HOMEPAGE="http://github.com/vincenthz/hs-tls"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~x86"
IUSE="+compat"
RESTRICT="test"

RDEPEND=">=dev-haskell/cereal-0.3:=[profile?]
	>=dev-haskell/certificate-1.3.0:=[profile?] <dev-haskell/certificate-1.4.0:=[profile?]
	>=dev-haskell/crypto-pubkey-0.2:=[profile?]
	>=dev-haskell/crypto-random-0.0.7:=[profile?] <dev-haskell/crypto-random-0.1:=[profile?]
	>=dev-haskell/cryptohash-0.6:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/network:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/cprng-aes-0.5
		>=dev-haskell/quickcheck-2
		dev-haskell/test-framework
		dev-haskell/test-framework-quickcheck2 )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag compat compat)
}
