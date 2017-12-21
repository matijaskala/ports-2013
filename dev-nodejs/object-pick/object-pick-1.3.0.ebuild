# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Returns a filtered copy of an object with only the specified keys, similar to '_.pick' from lodash / underscore."
HOMEPAGE="https://github.com/jonschlinkert/object.pick"
SRC_URI="https://registry.npmjs.org/${PN/-/.}/-/${P/-/.}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/isobject-3.0.1
"

src_install() {
	mv package ${PN/-/.}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN/-/.}
}
