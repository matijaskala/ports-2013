# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The lodash method '_.template' exported as a module."
HOMEPAGE="https://lodash.com/"
SRC_URI="https://registry.npmjs.org/lodash.template/-/lodash.template-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
S=${WORKDIR}

DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/lodash-templatesettings-4.0.0
	>=dev-nodejs/lodash-_reinterpolate-3.0.0
"

src_install() {
	mv package ${PN}
	insinto /usr/$(get_libdir)/node_modules
	doins -r ${PN}
}
