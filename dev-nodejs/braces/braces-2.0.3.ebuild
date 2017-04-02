# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast, comprehensive, bash-like brace expansion implemented in JavaScript. Complete support for the Bash 4.3 braces specification, without sacrificing speed."
HOMEPAGE="https://github.com/jonschlinkert/braces"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/array-unique-0.3.2
	>=dev-nodejs/to-regex-3.0.1
	>=dev-nodejs/fill-range-3.0.3
	>=dev-nodejs/snapdragon-0.8.1
	>=dev-nodejs/extend-shallow-2.0.1
	>=dev-nodejs/define-property-0.2.5
	>=dev-nodejs/repeat-element-1.1.2
	>=dev-nodejs/regex-not-1.0.0
	>=dev-nodejs/isobject-3.0.0
	>=dev-nodejs/arr-flatten-1.0.1
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
