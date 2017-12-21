# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Extended glob support for JavaScript. Adds (almost) the expressive power of regular expressions to glob patterns."
HOMEPAGE="https://github.com/micromatch/extglob"
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
	>=dev-nodejs/fragment-cache-0.2.1
	>=dev-nodejs/expand-brackets-2.1.4
	>=dev-nodejs/snapdragon-0.8.1
	>=dev-nodejs/extend-shallow-2.0.1
	>=dev-nodejs/define-property-1.0.0
	>=dev-nodejs/to-regex-3.0.1
	>=dev-nodejs/regex-not-1.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
