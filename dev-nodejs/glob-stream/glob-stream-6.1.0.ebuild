# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A Readable Stream interface over node-glob."
HOMEPAGE="https://github.com/gulpjs/glob-stream"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/ordered-read-streams-1.0.0
	>=dev-nodejs/glob-parent-3.1.0
	>=dev-nodejs/remove-trailing-separator-1.0.1
	>=dev-nodejs/extend-3.0.0
	>=dev-nodejs/glob-7.1.1
	>=dev-nodejs/pumpify-1.3.5
	>=dev-nodejs/is-negated-glob-1.0.0
	>=dev-nodejs/readable-stream-2.1.5
	>=dev-nodejs/unique-stream-2.0.2
	>=dev-nodejs/to-absolute-glob-2.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
