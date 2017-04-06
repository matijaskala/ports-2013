# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="String manipulation extensions for Underscore.js javascript library."
HOMEPAGE="http://epeli.github.com/underscore.string/"
SRC_URI="https://registry.npmjs.org/${PN/-/.}/-/${P/-/.}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/sprintf-js-1.0.3
	>=dev-nodejs/util-deprecate-1.0.2
"

src_install() {
	mv package ${PN/-/.}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN/-/.}
}
