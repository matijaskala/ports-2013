# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ktux/ktux-4.11.2.ebuild,v 1.4 2013/12/10 19:48:23 ago Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KDE: screensaver featuring the Space-Faring Tux"
HOMEPAGE+=" http://userbase.kde.org/KTux"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

# libkworkspace - only as a stub to provide KDE4Workspace config
DEPEND="
	$(add_kdebase_dep kscreensaver)
	$(add_kdebase_dep libkworkspace)
"
RDEPEND="${DEPEND}"
