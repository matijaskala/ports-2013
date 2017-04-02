# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Vinyl adapter for the file system"
HOMEPAGE="http://github.com/wearefractal/vinyl-fs"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/object-assign-4.0.0
	>=dev-nodejs/through2-2.0.0
	>=dev-nodejs/lazystream-1.0.0
	>=dev-nodejs/merge-stream-1.0.0
	>=dev-nodejs/strip-bom-2.0.0
	>=dev-nodejs/graceful-fs-4.0.0
	>=dev-nodejs/lodash-isequal-4.0.0
	>=dev-nodejs/gulp-sourcemaps-1.6.0
	>=dev-nodejs/mkdirp-0.5.0
	>=dev-nodejs/duplexify-3.2.0
	>=dev-nodejs/strip-bom-stream-1.0.0
	>=dev-nodejs/vali-date-1.0.0
	>=dev-nodejs/through2-filter-2.0.0
	>=dev-nodejs/vinyl-1.0.0
	>=dev-nodejs/readable-stream-2.0.4
	>=dev-nodejs/is-valid-glob-0.3.0
	>=dev-nodejs/glob-stream-5.3.2
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
