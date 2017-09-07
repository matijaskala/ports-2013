# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT_ID="34fcf8fc1af730883f27fe85636501d6d02c93ab"
DESCRIPTION="Gfxboot theme for Slontoo Live"
HOMEPAGE="https://github.com/matijaskala/slontoo-gfxboot"
SRC_URI="https://github.com/matijaskala/slontoo-gfxboot/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"
MAKEOPTS="-j1"

DEPEND="media-gfx/gfxboot"

S=${WORKDIR}/${PN}

src_unpack() {
	default
	mv ${PN}-${COMMIT_ID} ${PN} || die
}

src_compile() {
	rm data/isolinux.bin data/*.c32 || die
	default
}

src_install() {
	insinto /boot
	doins -r isolinux
}

pkg_postinst() {
	einfo "These isolinux modules are required:"
	for i in chain gfxboot ldlinux libcom32 mboot whichsys ; do
		einfo "  ${module}.c32"
	done
	einfo

	einfo "Retrieve them from /usr/share/syslinux along with 'isolinux.bin'"
	einfo "and manually copy them into 'isolinux' directory"
}
