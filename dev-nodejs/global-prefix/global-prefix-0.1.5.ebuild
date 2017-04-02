# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Get the npm global path prefix."
HOMEPAGE="https://github.com/jonschlinkert/global-prefix"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/is-windows-0.2.0
	>=dev-nodejs/ini-1.3.4
	>=dev-nodejs/homedir-polyfill-1.0.0
	>=dev-nodejs/which-1.2.12
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
