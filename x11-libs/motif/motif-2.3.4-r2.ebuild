# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/motif/motif-2.3.4-r2.ebuild,v 1.2 2014/05/01 09:25:25 ulm Exp $

EAPI=5

inherit autotools eutils flag-o-matic multilib toolchain-funcs multilib-minimal

DESCRIPTION="The Motif user interface component toolkit"
HOMEPAGE="http://sourceforge.net/projects/motif/
	http://motif.ics.com/"
SRC_URI="mirror://sourceforge/project/motif/Motif%20${PV}%20Source%20Code/${P}-src.tgz
	mirror://gentoo/${P}-patches-1.tar.xz"

LICENSE="LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="examples jpeg +motif22-compatibility png static-libs unicode xft"

RDEPEND="abi_x86_32? ( !app-emulation/emul-linux-x86-motif[-abi_x86_32(-)] )
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXmu[${MULTILIB_USEDEP}]
	x11-libs/libXp[${MULTILIB_USEDEP}]
	x11-libs/libXt[${MULTILIB_USEDEP}]
	jpeg? ( virtual/jpeg:0=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.4:0=[${MULTILIB_USEDEP}] )
	unicode? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	xft? (
		media-libs/fontconfig[${MULTILIB_USEDEP}]
		x11-libs/libXft[${MULTILIB_USEDEP}]
	)"

DEPEND="${RDEPEND}
	sys-devel/flex
	|| ( dev-util/byacc sys-freebsd/freebsd-ubin )
	x11-misc/xbitmaps"

src_prepare() {
	EPATCH_SUFFIX=patch epatch
	epatch_user

	# disable compilation of demo binaries
	sed -i -e '/^SUBDIRS/{:x;/\\$/{N;bx;};s/[ \t\n\\]*demos//;}' Makefile.am

	# add X.Org vendor string to aliases for virtual bindings
	echo -e '"The X.Org Foundation"\t\t\t\t\tpc' >>bindings/xmbind.alias

	AT_M4DIR=. eautoreconf

	# get around some LANG problems in make (#15119)
	LANG=C

	# bug #80421
	filter-flags -ftracer

	# feel free to fix properly if you care
	append-flags -fno-strict-aliasing

	# for Solaris Xos_r.h :(
	[[ ${CHOST} == *-solaris2.11 ]] \
		&& append-cppflags -DNEED_XOS_R_H -DHAVE_READDIR_R_3

	if use !elibc_glibc && use !elibc_uclibc && use unicode; then
		# libiconv detection in configure script doesn't always work
		# http://bugs.motifzone.net/show_bug.cgi?id=1423
		export LIBS="${LIBS} -liconv"
	fi

	# "bison -y" causes runtime crashes #355795
	export YACC=byacc
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--with-x \
		$(use_enable static-libs static) \
		$(use_enable motif22-compatibility) \
		$(use_enable unicode utf8) \
		$(use_enable xft) \
		$(use_enable jpeg) \
		$(use_enable png)
}

multilib_src_compile() {
	# The wmluiltok build tool is linked with libfl.a, therefore compile
	# it for the build platform's ABI
	emake -C tools/wml CC="$(tc-getBUILD_CC)" LIBS="-lfl" wmluiltok
	emake
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use examples; then
		emake -C demos DESTDIR="${D}" install-data
		dodir /usr/share/doc/${PF}/demos
		mv "${ED}"/usr/share/Xm/* "${ED}"/usr/share/doc/${PF}/demos || die
	fi
}

multilib_src_install_all() {
	# mwm default configs
	insinto /usr/share/X11/app-defaults
	newins "${FILESDIR}"/Mwm.defaults Mwm

	# cleanup
	rm -rf "${ED}"/usr/share/Xm
	prune_libtool_files

	dodoc BUGREPORT ChangeLog README RELEASE RELNOTES TODO
}
