# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libksane/libksane-4.11.3.ebuild,v 1.1 2013/11/05 22:23:06 dilfridge Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="SANE Library interface for KDE"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"
LICENSE="LGPL-2"

DEPEND="
	media-gfx/sane-backends
"
RDEPEND="${DEPEND}"
