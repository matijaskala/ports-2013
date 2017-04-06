# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The JavaScript Task Runner"
HOMEPAGE="http://gruntjs.com/"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/coffee-script-1.10.0
	>=dev-nodejs/grunt-legacy-util-1.0.0
	>=dev-nodejs/dateformat-1.0.12
	>=dev-nodejs/path-is-absolute-1.0.0
	>=dev-nodejs/glob-7.0.0
	>=dev-nodejs/grunt-legacy-log-1.0.0
	>=dev-nodejs/nopt-3.0.6
	>=dev-nodejs/exit-0.1.1
	>=dev-nodejs/iconv-lite-0.4.13
	>=dev-nodejs/eventemitter2-0.4.13
	>=dev-nodejs/js-yaml-3.5.2
	>=dev-nodejs/findup-sync-0.3.0
	>=dev-nodejs/grunt-cli-1.2.0
	>=dev-nodejs/minimatch-3.0.0
	>=dev-nodejs/grunt-known-options-1.1.0
	>=dev-nodejs/rimraf-2.2.8
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
