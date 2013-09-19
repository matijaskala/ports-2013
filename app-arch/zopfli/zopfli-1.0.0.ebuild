# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/zopfli/zopfli-1.0.0.ebuild,v 1.1 2013/09/18 20:43:23 tomwij Exp $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Compression library programmed in C to perform very good, but slow, deflate or zlib compression."
HOMEPAGE="https://code.google.com/p/zopfli/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-arch/unzip"

src_compile() {
	# Show what we run for a more verbose build log.
	local command="$(tc-getCC) src/${PN}/*.c -o ${PN} \
		-W -Wall -Wextra -ansi -pedantic -lm ${CFLAGS} ${LDFLAGS}"

	echo ${command} ; ${command} || die "Compilation failed."
}

src_install() {
	dobin ${PN}

	dodoc README CONTRIBUTORS

	insinto /usr/include/${PN}/
	doins src/${PN}/*.h
}
