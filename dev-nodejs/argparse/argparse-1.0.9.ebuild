# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Very powerful CLI arguments parser. Native port of argparse - python's options parsing library"
HOMEPAGE="https://github.com/nodeca/argparse"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/sprintf-js-1.0.2
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
