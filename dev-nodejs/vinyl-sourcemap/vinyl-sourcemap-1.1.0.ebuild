# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Add/write sourcemaps to/from Vinyl files."
HOMEPAGE="https://github.com/gulpjs/vinyl-sourcemap"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/graceful-fs-4.1.6
	>=dev-nodejs/append-buffer-1.0.2
	>=dev-nodejs/now-and-later-2.0.0
	>=dev-nodejs/remove-bom-buffer-3.0.0
	>=dev-nodejs/normalize-path-2.1.1
	>=dev-nodejs/convert-source-map-1.5.0
	>=dev-nodejs/vinyl-2.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
