# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Make a glob pattern absolute, ensuring that negative globs and patterns with trailing slashes are correctly handled."
HOMEPAGE="https://github.com/jonschlinkert/to-absolute-glob"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/extend-shallow-2.0.1
	>=dev-nodejs/is-absolute-0.2.5
	>=dev-nodejs/is-negated-glob-1.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
