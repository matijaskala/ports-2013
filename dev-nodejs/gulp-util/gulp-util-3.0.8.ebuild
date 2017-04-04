# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility functions for gulp plugins"
HOMEPAGE="https://github.com/gulpjs/gulp-util"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/event-stream-3.1.7
	>=dev-nodejs/object-assign-3.0.0
	>=dev-nodejs/through2-2.0.0
	>=dev-nodejs/array-uniq-1.0.2
	>=dev-nodejs/minimist-1.1.0
	>=dev-nodejs/dateformat-2.0.0
	>=dev-nodejs/multipipe-0.1.2
	>=dev-nodejs/fancy-log-1.1.0
	>=dev-nodejs/lodash-_reescape-3.0.0
	>=dev-nodejs/replace-ext-0.0.1
	>=dev-nodejs/chalk-1.0.0
	>=dev-nodejs/vinyl-0.5.0
	>=dev-nodejs/lodash-template-3.0.0
	>=dev-nodejs/lodash-_reinterpolate-3.0.0
	>=dev-nodejs/array-differ-1.0.0
	>=dev-nodejs/has-gulplog-0.1.0
	>=dev-nodejs/gulplog-1.0.0
	>=dev-nodejs/lodash-_reevaluate-3.0.0
	>=dev-nodejs/beeper-1.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
