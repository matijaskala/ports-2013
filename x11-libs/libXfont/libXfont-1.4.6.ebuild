# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXfont/libXfont-1.4.6.ebuild,v 1.10 2013/10/08 05:07:59 ago Exp $

EAPI=5

XORG_DOC=doc
inherit xorg-2

DESCRIPTION="X.Org Xfont library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 ipv6 truetype"

RDEPEND="x11-libs/xtrans
	x11-libs/libfontenc
	truetype? ( >=media-libs/freetype-2 )
	bzip2? ( app-arch/bzip2 )
	x11-proto/xproto
	x11-proto/fontsproto"
DEPEND="${RDEPEND}"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		$(use_enable doc devel-docs)
		$(use_with doc xmlto)
		$(use_with bzip2)
		$(use_enable truetype freetype)
		--without-fop
	)
	xorg-2_src_configure
}
