# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kppp/kppp-4.11.3.ebuild,v 1.1 2013/11/05 22:22:32 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE: A dialer and front-end to pppd."
HOMEPAGE="http://www.kde.org/applications/internet/kppp"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	net-dialup/ppp
"
