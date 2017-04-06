# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Grunt 0.4.x logger."
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
	>=dev-nodejs/grunt-legacy-log-utils-1.0.0
	>=dev-nodejs/colors-1.1.2
	>=dev-nodejs/underscore-string-3.2.3
	>=dev-nodejs/hooker-0.2.3
	>=dev-nodejs/lodash-3.10.1
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
