# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/drkonqi/drkonqi-4.11.3.ebuild,v 1.1 2013/11/05 22:22:35 dilfridge Exp $

EAPI=5

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="KDE crash handler, gives the user feedback if a program crashed"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs)
"
RDEPEND="${DEPEND}"

pkg_postinst() {
	kde4-meta_pkg_postinst
	if ! has_version "sys-devel/gdb"; then
		elog "For more usability consider installing following packages:"
		elog "    sys-devel/gdb - Easier debugging support"
	fi
}
