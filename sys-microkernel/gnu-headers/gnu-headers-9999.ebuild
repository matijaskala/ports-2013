# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GNU system headers"
HOMEPAGE="https://www.gnu.org/software/hurd/"
SRC_URI="mirror://gnu/gnumach/gnumach-1.8.tar.gz
	mirror://gnu/hurd/hurd-0.9.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

S=${WORKDIR}

: ${CTARGET:=${CHOST/x86_64/i686}}

src_configure() {
	cd gnumach-1.8
	[[ ${CATEGORY} == cross-* ]] && CTARGET=${CATEGORY#cross-}
	./configure \
		--prefix= \
		--host=${CTARGET} || die
}

src_compile() { :; }

src_install() {
	local ddir
	if [[ ${CATEGORY} == cross-* ]] ; then
		ddir=/usr/${CATEGORY#cross-}
	else
		ddir=
	fi

	pushd gnumach-1.8
		emake install-data DESTDIR="${ED}"${ddir}
		rm "${ED}"${ddir}/share/info/dir || die
	popd

	pushd hurd-0.9
		emake install-headers \
			INSTALL_DATA="/bin/sh \"${WORKDIR}/hurd-0.9/install-sh\" -c -C -m 644" \
			includedir="${ED}"${ddir}/include infodir=/some/path
	popd
}
