# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-sounds/kdeartwork-sounds-4.11.3.ebuild,v 1.1 2013/11/05 22:23:12 dilfridge Exp $

EAPI=5

RESTRICT="binchecks strip"

KMMODULE="sounds"
KMNAME="kdeartwork"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="Extra sound themes for kde"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
