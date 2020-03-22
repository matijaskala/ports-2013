# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="BSD version of gzip"
HOMEPAGE="https://www.freebsd.org"
SRC_URI="https://github.com/matijaskala/${PN}/archive/9feb6d38aa0c087c2fe48bbcfd8b12d82c470c44.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	dev-libs/libbsd
	sys-libs/zlib:="
RDEPEND="${DEPEND}
	!app-arch/gzip"

S=${WORKDIR}/${PN}-9feb6d38aa0c087c2fe48bbcfd8b12d82c470c44

src_prepare() {
	default

	tc-export CC
}
