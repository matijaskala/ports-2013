# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Return a copy of an object excluding the given key, or array of keys. Also accepts an optional filter function as the last argument."
HOMEPAGE="https://github.com/jonschlinkert/object.omit"
SRC_URI="https://registry.npmjs.org/object.omit/-/object.omit-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/is-extendable-0.1.1
	>=dev-nodejs/for-own-0.1.4
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
