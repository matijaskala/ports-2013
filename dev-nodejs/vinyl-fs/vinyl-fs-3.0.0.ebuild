# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Vinyl adapter for the file system."
HOMEPAGE="https://github.com/gulpjs/vinyl-fs"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/remove-bom-stream-1.2.0
	>=dev-nodejs/lazystream-1.0.0
	>=dev-nodejs/lead-1.0.0
	>=dev-nodejs/fs-mkdirp-stream-1.0.0
	>=dev-nodejs/flush-write-stream-1.0.0
	>=dev-nodejs/glob-stream-6.1.0
	>=dev-nodejs/pumpify-1.3.5
	>=dev-nodejs/graceful-fs-4.0.0
	>=dev-nodejs/value-or-function-3.0.0
	>=dev-nodejs/remove-bom-buffer-3.0.0
	>=dev-nodejs/resolve-options-1.1.0
	>=dev-nodejs/through2-2.0.0
	>=dev-nodejs/vinyl-sourcemap-1.1.0
	>=dev-nodejs/vinyl-2.0.0
	>=dev-nodejs/object-assign-4.0.4
	>=dev-nodejs/is-valid-glob-1.0.0
	>=dev-nodejs/to-through-2.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
