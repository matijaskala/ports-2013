# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Find the first file matching a given pattern in the current directory or the nearest ancestor directory."
HOMEPAGE="https://github.com/cowboy/node-findup-sync"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/detect-file-0.1.0
	>=dev-nodejs/is-glob-2.0.1
	>=dev-nodejs/micromatch-2.3.7
	>=dev-nodejs/resolve-dir-0.1.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
