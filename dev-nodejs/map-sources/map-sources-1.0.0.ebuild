# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Source map support for Gulp.js"
HOMEPAGE="http://github.com/floridoo/gulp-sourcemaps"
SRC_URI="https://registry.npmjs.org/@gulp-sourcemaps/${PN}/-/${P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/normalize-path-2.0.1
	>=dev-nodejs/through2-2.0.3
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules/@gulp-sourcemaps
	doins -r ${PN}
}
