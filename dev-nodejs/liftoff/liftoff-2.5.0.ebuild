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
	>=dev-nodejs/rechoir-0.6.2
	>=dev-nodejs/object-map-1.0.0
	>=dev-nodejs/is-plain-object-2.0.4
	>=dev-nodejs/findup-sync-2.0.0
	>=dev-nodejs/flagged-respawn-1.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
