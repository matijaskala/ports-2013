# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU Mach microkernel"
HOMEPAGE="https://www.gnu.org/software/hurd/microkernel/mach/gnumach.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="headers-only"
RESTRICT="mirror"

: ${CTARGET:=${CHOST/x86_64/i686}}
if [[ ${CTARGET} == ${CHOST} ]] && [[ ${CATEGORY} == cross-* ]] ; then
	export CTARGET=${CATEGORY#cross-}
fi

just_headers() {
	[[ ${CTARGET} != ${CHOST} ]] && use headers-only
}

src_configure() {
	[[ ${CATEGORY} == cross-* ]] && CTARGET=${CATEGORY#cross-}
	unset LDFLAGS
	./configure \
		--prefix=/usr \
		--exec-prefix= \
		--host=${CTARGET} || die
}

src_compile() {
	just_headers || emake gnumach.gz
}

src_install() {
	local ddir
	if [[ ${CATEGORY} == cross-* ]] ; then
		ddir=/usr/${CATEGORY#cross-}
	else
		ddir=
	fi
	if just_headers ; then
		emake install-data DESTDIR="${ED}${ddir}"
	else
		emake install DESTDIR="${ED}${ddir}"
	fi
	rm -f "${ED}${ddir}"/usr/share/info/dir || die
}
