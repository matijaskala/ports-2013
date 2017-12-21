# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Assign the enumerable es6 Symbol properties from an object (or objects) to the first object passed on the arguments. Can be used as a supplement to other extend, assign or merge methods as a polyfill for the Symbols part of the es6 Object.assign method."
HOMEPAGE="https://github.com/jonschlinkert/assign-symbols"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
