# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/cipher-rc4/cipher-rc4-0.1.4.ebuild,v 1.1 2013/12/11 05:24:01 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.4.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Fast RC4 cipher implementation"
HOMEPAGE="http://github.com/vincenthz/hs-cipher-rc4"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/byteable:=[profile?]
	>=dev-haskell/crypto-cipher-types-0.0.5:=[profile?] <dev-haskell/crypto-cipher-types-0.1:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/crypto-cipher-tests-0.0.7
		>=dev-haskell/quickcheck-2
		>=dev-haskell/test-framework-0.3.3
		>=dev-haskell/test-framework-quickcheck2-0.2.9 )
"
