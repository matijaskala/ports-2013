# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Easy-to-use plugin system for creating powerful, fast and versatile parsers and compilers, with built-in source-map support."
HOMEPAGE="https://github.com/jonschlinkert/snapdragon"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/source-map-0.5.6
	>=dev-nodejs/snapdragon-util-2.1.1
	>=dev-nodejs/use-2.0.2
	>=dev-nodejs/get-value-2.0.6
	>=dev-nodejs/map-cache-0.2.2
	>=dev-nodejs/isobject-3.0.0
	>=dev-nodejs/extend-shallow-2.0.1
	>=dev-nodejs/define-property-0.2.5
	>=dev-nodejs/snapdragon-node-1.0.6
	>=dev-nodejs/debug-2.6.2
	>=dev-nodejs/component-emitter-1.2.1
	>=dev-nodejs/source-map-resolve-0.5.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
