# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/sawfish/sawfish-1.9.1-r1.ebuild,v 1.3 2013/11/30 20:08:01 pacho Exp $

EAPI=5
inherit eutils

DESCRIPTION="Extensible window manager using a Lisp-based scripting language"
HOMEPAGE="http://sawfish.wikia.com/"
SRC_URI="http://download.tuxfamily.org/sawfish/${P}.tar.xz"

LICENSE="GPL-2 Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="nls xinerama"

RDEPEND=">=dev-libs/librep-0.92.1
	>=x11-libs/rep-gtk-0.90.7
	|| ( x11-libs/pangox-compat <x11-libs/pango-1.31[X] )
	>=x11-libs/gtk+-2.24.0:2
	x11-libs/libXtst
	nls? ( sys-devel/gettext )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_prepare() {
	# Fix firefox resizing problems, bug #462016
	epatch "${FILESDIR}/${P}-firefox.patch"
}

src_configure() {
	set -- \
		$(use_with xinerama) \
		--with-gdk-pixbuf \
		--disable-static

	if ! use nls; then
		# Use a space because configure script reads --enable-linguas="" as
		# "install everything"
		# Don't use --disable-linguas, because that means --enable-linguas="no",
		# which means "install Norwegian translations"
		set -- "$@" --enable-linguas=" "
	elif [[ "${LINGUAS+set}" == "set" ]]; then
		strip-linguas -i po
		set -- "$@" --enable-linguas=" ${LINGUAS} "
	else
		set -- "$@" --enable-linguas=""
	fi

	econf "$@"
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
	dodoc AUTHORS ChangeLog DOC FAQ NEWS OPTIONS README README.IMPORTANT TODO
}
