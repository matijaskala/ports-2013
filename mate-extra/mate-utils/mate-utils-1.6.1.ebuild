# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit mate

DESCRIPTION="Utilities for the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="applet ipv6 test"

RDEPEND=">=dev-libs/glib-2.20:2
	>=x11-libs/gtk+-2.20:2
	>=gnome-base/libgtop-2.12
	>=media-libs/libcanberra-0.4[gtk]
	x11-libs/libXext
	x11-libs/libX11
	applet? ( >=mate-base/mate-panel-1.5.0 )"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	>=app-text/mate-doc-utils-1.5.0
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	>=mate-base/mate-common-1.5.0"
src_prepare() {
	gnome2_src_prepare

	# Remove idiotic -D.*DISABLE_DEPRECATED cflags
	# This method is kinda prone to breakage. Recheck carefully with next bump.
	# bug 339074
	LC_ALL=C find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 1 failed"
	# Do Makefile.in after Makefile.am to avoid automake maintainer-mode
	LC_ALL=C find . -iname 'Makefile.in' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 2 failed"

	if ! use test; then
		sed -e 's/ tests//' -i logview/Makefile.{am,in} || die "sed 3 failed"
	fi

	# Are we need this?
	# Fix intltoolize broken file, see upstream #577133
	# sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
	#	|| die "sed failed"
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README THANKS"

	local myconf
	if ! use debug; then
		myconf="${myconf} --enable-debug=minimum"
	fi

	gnome2_src_configure \
		$(use_enable ipv6) \
		$(use_enable applet gdict-applet) \
		--disable-maintainer-flags \
		--enable-zlib \
		${myconf}
}
