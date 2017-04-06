# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="JavaScript sprintf implementation"
HOMEPAGE="https://github.com/alexei/sprintf.js"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
