# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Parse a glob pattern into an object of tokens."
HOMEPAGE="https://github.com/jonschlinkert/parse-glob"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/glob-base-0.3.0
	>=dev-nodejs/is-extglob-1.0.0
	>=dev-nodejs/is-glob-2.0.0
	>=dev-nodejs/is-dotfile-1.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
