# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The grunt command line interface"
HOMEPAGE="https://github.com/gruntjs/grunt-cli"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/findup-sync-0.3.0
	>=dev-nodejs/resolve-1.1.0
	>=dev-nodejs/nopt-3.0.6
	>=dev-nodejs/grunt-known-options-1.1.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
