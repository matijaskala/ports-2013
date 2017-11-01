# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vala

COMMIT_ID="47071b0d665bcb425f9d80927904fba825e4787d"
DESCRIPTION=".br compression utility"
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

src_compile() {
	showcmd() {
		echo "$@"
		"$@"
	}
	showcmd ${VALAC} brzip.gs libbrotlienc.vapi libbrotlidec.vapi xxhash.vapi --pkg=posix --ccode || die
	if [[ ${KERNEL} == linux ]] ; then
		showcmd $(tc-getCC) ${CFLAGS} $(pkg-config --cflags --libs glib-2.0 libbrotlienc libbrotlidec) -lxxhash -lbtrfs -o brzip$(get_exeext) brzip.c || die
	else
		showcmd $(tc-getCC) ${CFLAGS} $(pkg-config --cflags --libs glib-2.0 libbrotlienc libbrotlidec) -lxxhash -o brzip$(get_exeext) brzip.c crc32c.c || die
	fi
}

src_install() {
	dobin brzip$(get_exeext)
	dosym brzip$(get_exeext) /usr/bin/brcat$(get_exeext)
	dosym brzip$(get_exeext) /usr/bin/brunzip$(get_exeext)
	doman brzip.1
}
