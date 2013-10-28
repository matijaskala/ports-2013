# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/doctest/doctest-0.9.9.ebuild,v 1.1 2013/10/20 02:22:02 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.4.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Test interactive Haskell examples"
HOMEPAGE="https://github.com/sol/doctest-haskell#readme"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/deepseq:=[profile?]
	>=dev-haskell/ghc-paths-0.1.0.9:=[profile?]
	>=dev-haskell/syb-0.3:=[profile?] <dev-haskell/syb-0.5:=[profile?]
	dev-haskell/transformers:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/base-compat-0.2.1
		>=dev-haskell/hspec-1.5.1
		dev-haskell/hunit
		>=dev-haskell/quickcheck-2.5
		dev-haskell/setenv
		>=dev-haskell/silently-1.2.4
		>=dev-haskell/stringbuilder-0.4 )
"
