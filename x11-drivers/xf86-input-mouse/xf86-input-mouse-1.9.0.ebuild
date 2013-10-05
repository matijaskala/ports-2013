# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-mouse/xf86-input-mouse-1.9.0.ebuild,v 1.5 2013/10/04 12:01:11 ago Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org driver for mouse input devices"

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.7"
DEPEND="${RDEPEND}"
