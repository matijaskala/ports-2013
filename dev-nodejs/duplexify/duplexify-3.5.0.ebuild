# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Turn a writable and readable stream into a streams2 duplex stream with support for async initialization and streams1/streams2 input"
HOMEPAGE="https://github.com/mafintosh/duplexify"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/inherits-2.0.1
	>=dev-nodejs/end-of-stream-1.0.0
	>=dev-nodejs/stream-shift-1.0.0
	>=dev-nodejs/readable-stream-2.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
