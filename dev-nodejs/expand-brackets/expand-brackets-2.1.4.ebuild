# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Expand POSIX bracket expressions (character classes) in glob patterns."
HOMEPAGE="https://github.com/jonschlinkert/expand-brackets"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/to-regex-3.0.1
	>=dev-nodejs/regex-not-1.0.0
	>=dev-nodejs/snapdragon-0.8.1
	>=dev-nodejs/extend-shallow-2.0.1
	>=dev-nodejs/define-property-0.2.5
	>=dev-nodejs/posix-character-classes-0.1.0
	>=dev-nodejs/debug-2.3.3
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
