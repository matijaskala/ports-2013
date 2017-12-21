# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a little globber"
HOMEPAGE="https://github.com/isaacs/node-glob"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/inherits-2
	>=dev-nodejs/minimatch-3.0.4
	>=dev-nodejs/inflight-1.0.4
	>=dev-nodejs/fs-realpath-1.0.0
	>=dev-nodejs/path-is-absolute-1.0.0
	>=dev-nodejs/once-1.3.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
