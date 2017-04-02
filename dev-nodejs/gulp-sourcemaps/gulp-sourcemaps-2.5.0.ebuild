# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Source map support for Gulp.js"
HOMEPAGE="http://github.com/floridoo/gulp-sourcemaps"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/source-map-0
	>=dev-nodejs/through2-2
	>=dev-nodejs/acorn-4
	>=dev-nodejs/strip-bom-3
	>=dev-nodejs/graceful-fs-4
	>=dev-nodejs/detect-newline-2
	>=dev-nodejs/vinyl-1
	>=dev-nodejs/convert-source-map-1
	dev-nodejs/debug-fabulous
	>=dev-nodejs/css-2
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
