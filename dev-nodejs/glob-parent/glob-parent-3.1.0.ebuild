# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Strips glob magic from a string to provide the parent directory path"
HOMEPAGE="https://github.com/es128/glob-parent"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/is-glob-3.1.0
	>=dev-nodejs/path-dirname-1.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
