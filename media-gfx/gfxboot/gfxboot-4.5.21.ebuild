# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Graphical boot screen for GRUB, LILO, and SYSLINUX"
HOMEPAGE="https://github.com/openSUSE/gfxboot"
SRC_URI="https://github.com/openSUSE/gfxboot/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="x86 amd64"

DEPEND="app-arch/cpio
	dev-lang/nasm
	media-libs/freetype
	app-text/xmlto
	dev-libs/libxslt
	app-text/docbook-xml-dtd:4.1.2
	dev-perl/HTML-Parser"
RDEPEND="${DEPEND}"
RESTRICT="mirror"

src_prepare() {
	sed -i "/^all:/s/changelog//" Makefile || die
	sed -i "s/^BRANCH.*/BRANCH := /" Makefile || die
	sed -i "s/^VERSION.*/VERSION := ${PV}/" Makefile || die
	eapply "${FILESDIR}"/gfxboot-fix_warning.patch
	eapply_user
}
