# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/pixman/pixman-0.32.4.ebuild,v 1.9 2013/12/08 17:05:19 ago Exp $

EAPI=5
XORG_MULTILIB=yes
inherit xorg-2 toolchain-funcs versionator

EGIT_REPO_URI="git://anongit.freedesktop.org/git/pixman"
DESCRIPTION="Low-level pixel manipulation routines"

KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="altivec iwmmxt loongson2f mmxext neon sse2 ssse3"
RDEPEND="abi_x86_32? (
	!<=app-emulation/emul-linux-x86-gtklibs-20131008
	!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable mmxext mmx)
		$(use_enable sse2)
		$(use_enable ssse3)
		$(use_enable altivec vmx)
		$(use_enable neon arm-neon)
		$(use_enable iwmmxt arm-iwmmxt)
		$(use_enable loongson2f loongson-mmi)
		--disable-gtk
		--disable-libpng
	)
	xorg-2_src_configure
}
