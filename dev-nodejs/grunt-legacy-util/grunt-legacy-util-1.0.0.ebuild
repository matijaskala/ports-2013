# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Some old grunt utils provided for backwards compatibility."
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
	>=dev-nodejs/underscore-string-3.2.3
	>=dev-nodejs/lodash-4.3.0
	>=dev-nodejs/getobject-0.1.0
	>=dev-nodejs/exit-0.1.1
	>=dev-nodejs/which-1.2.1
	>=dev-nodejs/async-1.5.2
	>=dev-nodejs/hooker-0.2.3
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
