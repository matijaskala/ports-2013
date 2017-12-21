# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The streaming build system"
HOMEPAGE="http://gulpjs.com"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/pretty-hrtime-1.0.0
	>=dev-nodejs/semver-4.1.0
	>=dev-nodejs/orchestrator-0.3.0
	>=dev-nodejs/minimist-1.1.0
	>=dev-nodejs/vinyl-fs-0.3.0
	>=dev-nodejs/deprecated-0.0.1
	>=dev-nodejs/tildify-1.0.0
	>=dev-nodejs/chalk-1.0.0
	>=dev-nodejs/archy-1.0.0
	>=dev-nodejs/liftoff-2.1.0
	>=dev-nodejs/gulp-util-3.0.0
	>=dev-nodejs/interpret-1.0.0
	>=dev-nodejs/v8flags-2.0.2
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
