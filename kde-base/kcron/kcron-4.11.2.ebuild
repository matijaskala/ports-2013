# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcron/kcron-4.11.2.ebuild,v 1.5 2013/12/11 20:27:19 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Task Scheduler"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="!prefix? ( virtual/cron )"
