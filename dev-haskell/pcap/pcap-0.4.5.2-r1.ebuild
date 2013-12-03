# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/pcap/pcap-0.4.5.2-r1.ebuild,v 1.7 2013/11/24 12:47:05 pacho Exp $

EAPI=5

# ebuild generated by hackport 0.3.1.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="A system-independent interface for user-level packet capture"
HOMEPAGE="https://github.com/bos/pcap"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-haskell/network:=[profile?]
		>=dev-lang/ghc-6.12.1:=
		net-libs/libpcap"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"
