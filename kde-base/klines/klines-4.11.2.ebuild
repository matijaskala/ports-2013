# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/klines/klines-4.11.2.ebuild,v 1.3 2013/12/09 05:44:53 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="games"
inherit kde4-base

DESCRIPTION="KDE: Kolor Lines - a little game about balls and how to get rid of them"
HOMEPAGE="
	http://www.kde.org/applications/games/klines/
	http://games.kde.org/game.php?game=klines
"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="$(add_kdebase_dep libkdegames)"
RDEPEND="${DEPEND}"
