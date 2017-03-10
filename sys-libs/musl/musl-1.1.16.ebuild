# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic multilib-minimal
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.musl-libc.org/musl"
	inherit git-r3
	SRC_URI="
	http://dev.gentoo.org/~blueness/musl-misc/getconf.c
	http://dev.gentoo.org/~blueness/musl-misc/getent.c
	http://dev.gentoo.org/~blueness/musl-misc/iconv.c"
	KEYWORDS=""
else
	SRC_URI="http://www.musl-libc.org/releases/${P}.tar.gz
	http://dev.gentoo.org/~blueness/musl-misc/getconf.c
	http://dev.gentoo.org/~blueness/musl-misc/getent.c
	http://dev.gentoo.org/~blueness/musl-misc/iconv.c"
	KEYWORDS="-* ~amd64 ~arm ~mips ~ppc ~x86"
fi

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

DESCRIPTION="Light, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"
LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE="crosscompile_opts_headers-only"

MUSL_SONAME="libc.so.20170128"

PATCHES=(
	"${FILESDIR}/nftw.patch"
	"${FILESDIR}/qsort.patch"
	"${FILESDIR}/stdlib.patch"
	"${FILESDIR}/strdupa.patch"
	"${FILESDIR}/realpath.patch"
)

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

just_headers() {
	use crosscompile_opts_headers-only && is_crosscompile
}

pkg_setup() {
	if ! is_crosscompile ; then
		case ${CHOST} in
		*-musl*) ;;
		*) die "Use sys-devel/crossdev to build a musl toolchain" ;;
		esac
	fi
}

src_prepare() {
	default
	sed -i 's@^\(\$(DESTDIR)\$(includedir)/bits\)/@\1$(MY_ABI)/@' Makefile || die
	sed -i 's@^\(ALL_INCLUDES = \$(sort \$(INCLUDES:\$(srcdir)/%=%) \$(GENH:obj/%=%) \).*$@\1$(ARCH_INCLUDES:$(srcdir)/arch/$(ARCH)/bits/%=include/bits$(MY_ABI)/%) $(GENERIC_INCLUDES:$(srcdir)/arch/generic/bits/%=include/bits$(MY_ABI)/%))@' Makefile || die
	while grep obj/include/bits/ Makefile ; do
		sed -i 's@\(obj/include/bits\)/@\1$(MY_ABI)/@' Makefile || die
	done
	sed -i "s@\(-Wl,-e,_dlstart\)@\1,-soname,${MUSL_SONAME}@" Makefile || die
}

multilib_src_configure() {
	tc-getCC $(get_abi_CTARGET)
	just_headers && export CC=true
	is_crosscompile && export CROSS_COMPILE=${CTARGET}-

	local sysroot
	is_crosscompile && sysroot=/usr/${CTARGET}
	"${S}"/configure \
		--target=$(get_abi_CTARGET) \
		--prefix=${sysroot}/usr \
		--syslibdir=${sysroot}/$(get_libdir) \
		--libdir=${sysroot}/usr/$(get_libdir) \
		--disable-gcc-wrapper || die
}

header_wrapper() {
	cat << EOF
#if defined(__x86_64__)
#  if defined(__ILP32__)
#    include <bitsx32/$1>
#  else
#    include <bits64/$1>
# endif
#elif defined(__i386__)
#  include <bits32/$1>
#elif defined(__mips__)
#  if(_MIPS_SIM == _ABIO32)
#    include <bitso32/$1>
#  elif(_MIPS_SIM == _ABIN32)
#    include <bitsn32/$1>
#  elif(_MIPS_SIM == _ABI64)
#    include <bitsn64/$1>
#  else
#    error
#  endif
#elif defined(__powerpc__)
#  if defined(__powerpc64__)
#    include <bits64/$1>
#  else
#    include <bits32/$1>
#  endif
#endif
EOF
}

musl_export_abi() {
	case ${ABI} in
		x32|o32|n32|n64) MY_ABI=${ABI} ;;
		amd64|ppc64) MY_ABI=64 ;;
		x86|ppc) MY_ABI=32 ;;
		default|${DEFAULT_ABI}) MY_ABI= ;;
		*) die ;;
	esac
	export MY_ABI
}

multilib_src_compile() {
	musl_export_abi

	mkdir -p obj/include/bits || die
	for i in $(ls -1 "${S}"/arch/*/bits | sort -u) ; do
		[[ -z ${MY_ABI} ]] || header_wrapper ${i%.in} > obj/include/bits/${i%.in}
	done

	emake obj/include/bits${MY_ABI}/alltypes.h
	just_headers && return 0

	emake

	if multilib_is_native_abi && ! is_crosscompile ; then
		$(tc-getCC) ${CFLAGS} "${DISTDIR}"/getconf.c -o "${T}"/getconf || die
		$(tc-getCC) ${CFLAGS} "${DISTDIR}"/getent.c -o "${T}"/getent || die
		$(tc-getCC) ${CFLAGS} "${DISTDIR}"/iconv.c -o "${T}"/iconv || die
	fi
}

multilib_src_install() {
	musl_export_abi

	if just_headers ; then
		emake DESTDIR="${D}" install-headers
	else
		[[ -e "${T}"/ldconfig ]] || head -n 3 "${FILESDIR}"/ldconfig.in > "${T}"/ldconfig || die
		emake DESTDIR="${D}" install
		local sysroot
		is_crosscompile && sysroot=/usr/${CTARGET}
		local arch=$("${D}"${sysroot}/usr/$(get_libdir)/libc.so 2>&1 | sed -n '1s/^musl libc (\(.*\))$/\1/p')
		rm "${D}"${sysroot}/$(get_libdir)/ld-musl-${arch}.so.1 || die
		tail -n +4 "${FILESDIR}"/ldconfig.in | sed \
			-e "s|@@ARCH@@|${arch}|" \
			-e "s|/lib|/$(get_libdir)|" \
			-e "s|\(/$(get_libdir)\)\(.*\)/lib|\1\2\1|" \
			>> "${T}"/ldconfig || die
		cp "${D}"${sysroot}/usr/$(get_libdir)/libc.so "${D}"${sysroot}/usr/$(get_libdir)/${MUSL_SONAME} || die
		multilib_is_native_abi && dosym ../$(get_libdir)/${MUSL_SONAME} ${sysroot}/bin/ldd
		gen_usr_ldscript -a c
		dosym ${MUSL_SONAME} ${sysroot}/$(get_libdir)/ld-musl-${arch}.so.1
		if [[ $(get_libdir) != "lib" ]] ; then
			dosym ../$(get_libdir)/${MUSL_SONAME} ${sysroot}/lib/ld-musl-${arch}.so.1
		fi
	fi
}

multilib_src_install_all() {
	local sysroot
	is_crosscompile && sysroot=/usr/${CTARGET}
	[[ -e ${D}${sysroot}/usr/include/bits ]] && [[ -e ${D}${sysroot}/usr/include/bits?* ]] && die
	for i in $(find "${D}"${sysroot}/usr/include/bits?* -type f | sed 's@^.*/\([^/]*\)$@\1@' | sort -u) ; do
		insinto ${sysroot}/usr/include/bits
		header_wrapper ${i} | newins - ${i}
	done
	just_headers && return 0

	into ${sysroot:-/}
	dosbin "${T}"/ldconfig
	if ! is_crosscompile ; then
		into ${sysroot}/usr
		dobin "${T}"/getconf
		dobin "${T}"/getent
		dobin "${T}"/iconv
	fi
	echo 'LDPATH="include ld.so.conf.d/*.conf"' > "${T}"/00musl || die
	insinto ${sysroot}/etc/env.d
	doins "${T}"/00musl || die
}
