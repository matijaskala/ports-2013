# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Glob matching for javascript/node.js. A drop-in replacement and faster alternative to minimatch and multimatch."
HOMEPAGE="https://github.com/jonschlinkert/micromatch"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/array-unique-0.2.1
	>=dev-nodejs/arr-diff-2.0.0
	>=dev-nodejs/parse-glob-3.0.4
	>=dev-nodejs/is-glob-2.0.1
	>=dev-nodejs/expand-brackets-0.1.4
	>=dev-nodejs/regex-cache-0.4.2
	>=dev-nodejs/object-omit-2.0.0
	>=dev-nodejs/filename-regex-2.0.0
	>=dev-nodejs/normalize-path-2.0.1
	>=dev-nodejs/kind-of-3.0.2
	>=dev-nodejs/extglob-0.3.1
	>=dev-nodejs/is-extglob-1.0.0
	>=dev-nodejs/braces-1.8.2
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
