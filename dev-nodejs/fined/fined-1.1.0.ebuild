# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Find a file given a declaration of locations"
HOMEPAGE="https://github.com/js-cli/fined"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/object-defaults-1.1.0
	>=dev-nodejs/expand-tilde-2.0.2
	>=dev-nodejs/parse-filepath-1.0.1
	>=dev-nodejs/is-plain-object-2.0.3
	>=dev-nodejs/object-pick-1.2.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
