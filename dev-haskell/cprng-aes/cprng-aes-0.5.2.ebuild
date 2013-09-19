# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/cprng-aes/cprng-aes-0.5.2.ebuild,v 1.1 2013/09/13 05:51:32 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Crypto Pseudo Random Number Generator using AES in counter mode."
HOMEPAGE="http://github.com/vincenthz/hs-cprng-aes"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/byteable:=[profile?]
	>=dev-haskell/cipher-aes-0.2:=[profile?] <dev-haskell/cipher-aes-0.3:=[profile?]
	>=dev-haskell/crypto-random-0.0.7:=[profile?] <dev-haskell/crypto-random-0.1:=[profile?]
	dev-haskell/random:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
"
