# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksirk/ksirk-4.11.2.ebuild,v 1.3 2013/12/09 05:44:34 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE: Ksirk is a KDE port of the board game risk"
HOMEPAGE="
	http://www.kde.org/applications/games/ksirk/
	http://games.kde.org/game.php?game=ksirk
"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-crypt/qca:2
	$(add_kdebase_dep libkdegames)
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
