# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Returns true if a value has the characteristics of a valid JavaScript descriptor. Works for data descriptors and accessor descriptors."
HOMEPAGE="https://github.com/jonschlinkert/is-descriptor"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/is-accessor-descriptor-0.1.6
	>=dev-nodejs/is-data-descriptor-0.1.4
	>=dev-nodejs/kind-of-5.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
