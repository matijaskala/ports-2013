# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Use node's fs.realpath, but fall back to the JS implementation if the native one fails"
HOMEPAGE="https://github.com/isaacs/fs.realpath"
SRC_URI="https://registry.npmjs.org/fs.realpath/-/fs.realpath-${PV}.tgz"

LICENSE="ISC"
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
