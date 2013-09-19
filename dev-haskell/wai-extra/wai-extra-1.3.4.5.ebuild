# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/wai-extra/wai-extra-1.3.4.5.ebuild,v 1.1 2013/09/13 06:42:03 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Provides some basic WAI handlers and middleware."
HOMEPAGE="http://github.com/yesodweb/wai"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/ansi-terminal:=[profile?]
	dev-haskell/base64-bytestring:=[profile?]
	>=dev-haskell/blaze-builder-0.2.1.4:=[profile?] <dev-haskell/blaze-builder-0.4:=[profile?]
	>=dev-haskell/blaze-builder-conduit-0.5:=[profile?] <dev-haskell/blaze-builder-conduit-1.1:=[profile?]
	>=dev-haskell/case-insensitive-0.2:=[profile?]
	>=dev-haskell/conduit-0.5:=[profile?] <dev-haskell/conduit-1.1:=[profile?]
	dev-haskell/data-default:=[profile?]
	>=dev-haskell/date-cache-0.3:=[profile?] <dev-haskell/date-cache-0.4:=[profile?]
	>=dev-haskell/fast-logger-0.2:=[profile?] <dev-haskell/fast-logger-0.4:=[profile?]
	>=dev-haskell/http-types-0.7:=[profile?]
	dev-haskell/lifted-base:=[profile?]
	>=dev-haskell/network-2.2.1.5:=[profile?]
	>=dev-haskell/resourcet-0.3:=[profile?] <dev-haskell/resourcet-0.5:=[profile?]
	>=dev-haskell/stringsearch-0.3:=[profile?] <dev-haskell/stringsearch-0.4:=[profile?]
	>=dev-haskell/text-0.7:=[profile?] <dev-haskell/text-0.12:=[profile?]
	>=dev-haskell/transformers-0.2.2:=[profile?] <dev-haskell/transformers-0.4:=[profile?]
	>=dev-haskell/void-0.5:=[profile?]
	>=dev-haskell/wai-1.3:=[profile?] <dev-haskell/wai-1.5:=[profile?]
	>=dev-haskell/wai-logger-0.2:=[profile?] <dev-haskell/wai-logger-0.4:=[profile?]
	dev-haskell/word8:=[profile?]
	>=dev-haskell/zlib-conduit-0.5:=[profile?] <dev-haskell/zlib-conduit-1.1:=[profile?]
	>=dev-lang/ghc-6.12.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8.0.2
	test? ( >=dev-haskell/hspec-1.3
		dev-haskell/hunit
		>=dev-haskell/wai-test-1.3
		dev-haskell/zlib
		dev-haskell/zlib-bindings )
"
