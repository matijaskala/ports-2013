# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fill in a range of numbers or letters, optionally passing an increment or 'step' to use, or create a regex-compatible range with 'options.toRegex'"
HOMEPAGE="https://github.com/jonschlinkert/fill-range"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/repeat-string-1.6.1
	>=dev-nodejs/extend-shallow-2.0.1
	>=dev-nodejs/is-number-4.0.0
	>=dev-nodejs/to-regex-range-2.1.1
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
