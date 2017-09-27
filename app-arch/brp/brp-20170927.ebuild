# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vala

COMMIT_ID="16ff3e83d51f763513458a3a14fe0abe0cab2afa"
DESCRIPTION="Brotli packer"
HOMEPAGE="https://github.com/matijaskala/brp"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	app-arch/brotli:=
	dev-libs/xxhash
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	$(vala_depend)"

S=${WORKDIR}/${PN}-${COMMIT_ID}

src_prepare() {
	vala_src_prepare
	default
}

src_compile() {
	showcmd() {
		echo "$@"
		"$@"
	}
	showcmd ${VALAC} brp.gs libbrotlienc.vapi libbrotlidec.vapi xxhash.vapi --pkg=posix --ccode || die
	showcmd $(tc-getCC) ${CFLAGS} $(pkg-config --cflags --libs glib-2.0 libbrotlienc libbrotlidec) -lxxhash -lpthread -o ${PN}$(get_exeext) ${PN}.c crc32c.c || die
}

src_install() {
	dobin ${PN}$(get_exeext)
}
