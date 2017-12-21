# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Glob matching for javascript/node.js. A drop-in replacement and faster alternative to minimatch and multimatch."
HOMEPAGE="https://github.com/micromatch/micromatch"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/array-unique-0.3.2
	>=dev-nodejs/arr-diff-4.0.0
	>=dev-nodejs/fragment-cache-0.2.1
	>=dev-nodejs/object-pick-1.3.0
	>=dev-nodejs/snapdragon-0.8.1
	>=dev-nodejs/extend-shallow-2.0.1
	>=dev-nodejs/define-property-1.0.0
	>=dev-nodejs/regex-not-1.0.0
	>=dev-nodejs/kind-of-6.0.0
	>=dev-nodejs/extglob-2.0.2
	>=dev-nodejs/nanomatch-1.2.5
	>=dev-nodejs/braces-2.3.0
	>=dev-nodejs/to-regex-3.0.1
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
