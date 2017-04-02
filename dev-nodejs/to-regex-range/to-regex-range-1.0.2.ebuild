# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Returns a regex-compatible range from two numbers, min and max. Validated against more than 1.1 million generated unit tests that run in less than 400ms! Useful for creating regular expressions to validate numbers, ranges, years, etc."
HOMEPAGE="https://github.com/jonschlinkert/to-regex-range"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/repeat-string-1.5.4
	>=dev-nodejs/is-number-3.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
