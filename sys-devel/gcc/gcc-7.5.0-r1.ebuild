# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="3"

GMP_VER="6.1.2"
MPFR_VER="3.1.6"
MPC_VER="1.0.3"

inherit toolchain

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~ppc-macos"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi

src_prepare() {
	toolchain_src_prepare

	if use elibc_musl || [[ ${CATEGORY} == cross-*-musl* ]] ; then
		eapply "${FILESDIR}"/cpu_indicator.patch
		eapply "${FILESDIR}"/posix_memalign.patch
	fi
}
