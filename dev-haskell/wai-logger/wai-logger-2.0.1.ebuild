# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/wai-logger/wai-logger-2.0.1.ebuild,v 1.1 2013/12/11 05:17:31 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="A logging system for WAI"
HOMEPAGE="http://hackage.haskell.org/package/wai-logger"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/blaze-builder:=[profile?]
	dev-haskell/byteorder:=[profile?]
	dev-haskell/case-insensitive:=[profile?]
	>=dev-haskell/fast-logger-2.0.0:=[profile?]
	dev-haskell/http-types:=[profile?]
	dev-haskell/network:=[profile?]
	dev-haskell/unix-time:=[profile?]
	>=dev-haskell/wai-2.0.0:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.10
	test? ( dev-haskell/doctest
		dev-haskell/wai-test )
"
