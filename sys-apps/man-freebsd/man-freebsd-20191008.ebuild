# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FreeBSD commands to read man pages"
HOMEPAGE="https://www.freebsd.org"
SRC_URI="https://github.com/matijaskala/${PN}/archive/f857ffbe8fcc2c678017a6ae6174de7fdbea0e58.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="userland_GNU? ( sys-apps/which )
	sys-apps/groff
	!sys-apps/man
	!sys-apps/man-db
	!sys-apps/man-netbsd
	!sys-freebsd/freebsd-ubin"

S=${WORKDIR}/${PN}-f857ffbe8fcc2c678017a6ae6174de7fdbea0e58
