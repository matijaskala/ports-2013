# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Terminal string styling done right. Much color."
HOMEPAGE="https://github.com/chalk/chalk"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/strip-ansi-3.0.0
	>=dev-nodejs/escape-string-regexp-1.0.2
	>=dev-nodejs/supports-color-2.0.0
	>=dev-nodejs/ansi-styles-2.2.1
	>=dev-nodejs/has-ansi-2.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
