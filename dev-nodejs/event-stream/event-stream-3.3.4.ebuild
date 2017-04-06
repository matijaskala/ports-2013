# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="construct pipes of streams of events"
HOMEPAGE="http://github.com/dominictarr/event-stream"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/pause-stream-0.0.11
	dev-nodejs/from
	>=dev-nodejs/stream-combiner-0.0.4
	>=dev-nodejs/through-2.3.1
	>=dev-nodejs/split-0.3
	>=dev-nodejs/duplexer-0.1.1
	dev-nodejs/map-stream
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
