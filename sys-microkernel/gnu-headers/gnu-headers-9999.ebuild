# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MACH=gnumach-1.8
HURD=hurd-0.9

DESCRIPTION="GNU system headers"
HOMEPAGE="https://www.gnu.org/software/hurd/"
SRC_URI="mirror://gnu/gnumach/${MACH}.tar.gz
	mirror://gnu/hurd/${HURD}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

S=${WORKDIR}

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] && [[ ${CATEGORY} == cross-* ]] ; then
	export CTARGET=${CATEGORY#cross-}
else
	export CTARGET=${CTARGET/x86_64/i686}
fi

src_configure() {
	config() {
		echo ./configure "$@"
		./configure "$@"
	}
	cd "${MACH}" && config \
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

	emake -C "${MACH}" install-data DESTDIR="${ED}"${ddir}
	rm "${ED}"${ddir}/share/info/dir || die

	emake -C "${HURD}" install-headers \
		INSTALL_DATA="/bin/sh \"${WORKDIR}/${HURD}/install-sh\" -c -C -m 644" \
		includedir="${ED}"${ddir}/include infodir=/some/path
}
