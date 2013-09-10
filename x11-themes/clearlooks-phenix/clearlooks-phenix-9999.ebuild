# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/clearlooks-phenix/clearlooks-phenix-9999.ebuild,v 1.3 2013/06/08 13:41:20 hasufell Exp $

EAPI=5

inherit git-2

DESCRIPTION="Clearlooks-Phenix is a GTK+ 3 port of Clearlooks, the default theme for GNOME 2"
HOMEPAGE="http://www.jpfleury.net/en/software/clearlooks-phenix.php"
EGIT_REPO_URI="git://jpfleury.indefero.net/jpfleury/${PN}.git"

KEYWORDS=""
LICENSE="GPL-3"
SLOT="0"
IUSE=""

SLOT_BLOCK="!x11-themes/clearlooks-phenix:3.4
	!x11-themes/clearlooks-phenix:3.6"
RDEPEND="${SLOT_BLOCK}
	>=x11-libs/gtk+-3.6:3
	x11-themes/gtk-engines"

src_install() {
	insinto "/usr/share/themes/Clearlooks-Phenix"
	doins -r *
}
