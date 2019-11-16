# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NetBSD macro processor"
HOMEPAGE="https://www.netbsd.org"
COMMIT_ID="37ab9281aa0952bdd0cd44e62b2e82286f3f7fec"
SRC_URI="https://github.com/matijaskala/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

BDEPEND="sys-devel/flex
	virtual/yacc"
DEPEND="dev-libs/libbsd"
RDEPEND="${DEPEND}
	!sys-devel/m4
	!sys-freebsd/freebsd-ubin"

S=${WORKDIR}/${PN}-${COMMIT_ID}
