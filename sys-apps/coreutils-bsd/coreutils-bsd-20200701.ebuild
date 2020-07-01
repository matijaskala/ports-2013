# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Standard BSD utilities"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
COMMIT_ID="5e36d80810133d0debe93f6d1125419b40e4e222"
SRC_URI="https://github.com/matijaskala/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libbsd"
RDEPEND="${DEPEND}
	!sys-apps/coreutils
	!sys-apps/net-tools[hostname]
	!sys-apps/util-linux[kill]
	!sys-apps/which
	!sys-process/procps[kill]"

S=${WORKDIR}/${PN}-${COMMIT_ID}

src_prepare() {
	default

	tc-export CC
}

src_install() {
	default

	rm -f "${D}"/usr/bin/groups || die
	rm -f "${D}"/usr/share/man/man1/groups.1 || die
}
