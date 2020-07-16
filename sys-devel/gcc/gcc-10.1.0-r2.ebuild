# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="3"

GMP_VER="6.2.0"
MPFR_VER="4.1.0"
MPC_VER="1.1.0"

inherit toolchain

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

src_prepare() {
	toolchain_src_prepare

	if use elibc_musl || [[ ${CATEGORY} == cross-*-musl* ]] ; then
		eapply "${FILESDIR}"/cpu_indicator.patch
		eapply "${FILESDIR}"/posix_memalign.patch
	fi
}
