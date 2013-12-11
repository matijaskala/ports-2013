# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/wai-test/wai-test-2.0.0.1.ebuild,v 1.1 2013/12/11 06:50:35 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Unit test framework (built on HUnit) for WAI applications."
HOMEPAGE="http://www.yesodweb.com/book/web-application-interface"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/blaze-builder-0.2.1.4:=[profile?] <dev-haskell/blaze-builder-0.4:=[profile?]
	>=dev-haskell/blaze-builder-conduit-0.5:=[profile?] <dev-haskell/blaze-builder-conduit-1.1:=[profile?]
	>=dev-haskell/case-insensitive-0.2:=[profile?]
	>=dev-haskell/conduit-0.5:=[profile?] <dev-haskell/conduit-1.1:=[profile?]
	>=dev-haskell/cookie-0.2:=[profile?] <dev-haskell/cookie-0.5:=[profile?]
	>=dev-haskell/http-types-0.7:=[profile?]
	>=dev-haskell/hunit-1.2:=[profile?] <dev-haskell/hunit-1.3:=[profile?]
	dev-haskell/network:=[profile?]
	>=dev-haskell/text-0.7:=[profile?]
	>=dev-haskell/transformers-0.2.2:=[profile?] <dev-haskell/transformers-0.4:=[profile?]
	>=dev-haskell/wai-2.0:=[profile?] <dev-haskell/wai-2.1:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/hspec-1.3 )
"
