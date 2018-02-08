# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson vala

COMMIT_ID="3e8ae177890dc4970691d3b8b841b8a62ce0cb4e"
DESCRIPTION="A compression utility based on Brotli algorithm"
HOMEPAGE="https://github.com/matijaskala/brzip"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-libs/glib:2=
	app-arch/brotli:=
	dev-libs/xxhash:=
	kernel_linux? ( sys-fs/btrfs-progs:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	$(vala_depend)"

S=${WORKDIR}/${PN}-${COMMIT_ID}

src_prepare() {
	vala_src_prepare
	default
}

src_configure() {
	meson_src_configure \
		$(meson_use kernel_linux btrfs)
}
