# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gtk-gnutella/gtk-gnutella-1.0.0.ebuild,v 1.2 2013/10/29 22:22:38 chainsaw Exp $

EAPI=5

inherit eutils

IUSE="nls dbus ssl +gtk"

DESCRIPTION="A GTK+ Gnutella client"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://gtk-gnutella.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~x86 ~x86-fbsd"

RDEPEND="
	dev-libs/glib:2
	sys-libs/zlib
	gtk? ( >=x11-libs/gtk+-2.2.1:2 )
	dbus? ( >=sys-apps/dbus-0.35.2 )
	ssl? ( >=net-libs/gnutls-2.2.5 )
	nls? ( >=sys-devel/gettext-0.11.5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	strip-linguas -i po

	echo "# Gentoo-selected LINGUAS" > po/LINGUAS
	for ling in ${LINGUAS}; do
		echo $ling >> po/LINGUAS
	done

	# Already fixed upstream but not released yet. Included as requested
	# by upstream.
	epatch "${FILESDIR}/${P}-bdf.patch"
}

src_configure() {
	# There is no option to turn off optimization through the build.sh
	# script.
	sed -i -e "s/Configure -Oder/Configure -Oder -Doptimize=none/" build.sh || die

	# The build script does not support the equivalent --enable
	# options so we must construct the configuration by hand.

	local myconf

	if ! use nls; then
		myconf="${myconf} --disable-nls"
	fi

	if ! use dbus; then
		myconf="${myconf} --disable-dbus"
	fi

	if ! use ssl; then
		myconf="${myconf} --disable-gnutls"
	fi

	if use gtk; then
		myconf="${myconf} --gtk2"
	else
		myconf="${myconf} --topless"
	fi

	./build.sh \
		--configure-only \
		--prefix="/usr" \
		--cc=$(tc-getCC) \
		${myconf}
}

src_install() {
	dodir /usr/bin
	emake INSTALL_PREFIX="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog README TODO

	# Touch the symbols file into the future to avoid warnings from
	# gtk-gnutella later on, since we will most likely strip the binary.
	touch --date="next minute" "${D}/usr/lib/gtk-gnutella/gtk-gnutella.nm" || die
}
