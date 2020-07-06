# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson vala

COMMIT_ID="43e5577c91b710fe376887a510aa87de5ccd3b22"
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
	dev-libs/xxhash:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	$(vala_depend)"

S=${WORKDIR}/${PN}-${COMMIT_ID}

src_prepare() {
	vala_src_prepare
	default
}
