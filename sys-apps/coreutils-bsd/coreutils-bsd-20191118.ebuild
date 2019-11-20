# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Standard BSD utilities"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
COMMIT_ID="0da5f8c3a748ab9bbe47fa00dba306517c970661"
SRC_URI="https://github.com/matijaskala/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libbsd"
RDEPEND="${DEPEND}
	!sys-apps/coreutils
	!sys-apps/util-linux[kill]
	!sys-apps/which
	!sys-process/procps[kill]"

S=${WORKDIR}/${PN}-${COMMIT_ID}

src_install() {
	default

	rm -f "${D}"/usr/bin/groups || die
	rm -f "${D}"/usr/share/man/man1/groups.1 || die
}
