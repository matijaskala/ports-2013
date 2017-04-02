# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Launch your command line tool with ease."
HOMEPAGE="https://github.com/js-cli/js-liftoff"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/resolve-1.1.7
	>=dev-nodejs/extend-3.0.0
	>=dev-nodejs/fined-1.0.1
	>=dev-nodejs/lodash-mapvalues-4.4.0
	>=dev-nodejs/rechoir-0.6.2
	>=dev-nodejs/lodash-isstring-4.0.1
	>=dev-nodejs/lodash-isplainobject-4.0.4
	>=dev-nodejs/findup-sync-0.4.2
	>=dev-nodejs/flagged-respawn-0.3.2
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
