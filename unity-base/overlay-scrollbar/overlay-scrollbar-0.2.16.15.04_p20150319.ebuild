# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

UVER_PREFIX="+r359+15.04.20150319"
UPV=0.2.16

inherit autotools eutils ubuntu

DESCRIPTION="Ayatana Scrollbars use an overlay to ensure scrollbars take up no active screen real-estate"
HOMEPAGE="http://launchpad.net/ayatana-scrollbar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="gnome-base/dconf
	x11-libs/gtk+:2
	>=x11-libs/gtk+-3.8:3"
RDEPEND="$DEPEND"

src_prepare() {
	eautoreconf
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--disable-static \
		--disable-tests \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
		--disable-static \
		--disable-tests \
		--with-gtk=3 || die
	popd
}

src_compile() {
	# Build GTK2 support #
	pushd build-gtk2
	emake || die
	popd

	# Build GTK3 support #
	pushd build-gtk3
	emake || die
	popd
}

src_install() {
	# Install GTK2 support #
	pushd build-gtk2
	emake DESTDIR="${D}" install || die
	popd

	# Install GTK3 support #
	pushd build-gtk3
	emake DESTDIR="${D}" install || die
	popd

	rm -rf "${D}usr/etc" &> /dev/null
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe data/81overlay-scrollbar

	prune_libtool_files --modules
}
