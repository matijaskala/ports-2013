# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Like duplexer but using streams3"
HOMEPAGE="https://github.com/deoxxa/duplexer2"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/readable-stream-2.0.2
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
