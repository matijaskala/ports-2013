# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual file format."
HOMEPAGE="https://github.com/gulpjs/vinyl"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/clone-buffer-1.0.0
	>=dev-nodejs/cloneable-readable-1.0.0
	>=dev-nodejs/remove-trailing-separator-1.0.1
	>=dev-nodejs/clone-1.0.0
	>=dev-nodejs/replace-ext-1.0.0
	>=dev-nodejs/is-stream-1.1.0
	>=dev-nodejs/clone-stats-1.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
