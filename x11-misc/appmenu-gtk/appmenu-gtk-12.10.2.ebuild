# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Export GTK menus over DBus"
HOMEPAGE="https://launchpad.net/appmenu-gtk"
SRC_URI="http://launchpad.net/${PN}/12.10/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="+gtk3"
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=[gtk,gtk3?]"
DEPEND="${RDEPEND}
	x11-libs/gtk+:2
	<x11-libs/gtk+-3.8.0"

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--sysconfdir=/etc \
		--disable-static \
		--with-gtk2 || die
	popd

	if use gtk3; then
		# Build GTK3 support #
		[[ -d build-gtk3 ]] || mkdir build-gtk3
		pushd build-gtk3
		../configure --prefix=/usr \
			--sysconfdir=/etc \
			--disable-static || die
		popd
	fi
}

src_compile() {
	# Build GTK2 support #
	pushd build-gtk2
	emake || die
	popd

	if use gtk3; then
		# Build GTK3 support #
		pushd build-gtk3
		emake || die
		popd
	fi
}

src_install() {
	# Install GTK2 support #
	pushd build-gtk2
	emake DESTDIR="${D}" install || die
	popd

	if use gtk3; then
		# Install GTK3 support #
		pushd build-gtk3
		emake DESTDIR="${D}" install || die
		popd
	fi

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${D}etc/X11/Xsession.d/80appmenu"
	use gtk3 && doexe "${D}etc/X11/Xsession.d/80appmenu-gtk3"

	rm -rvf "${D}etc/X11/Xsession.d"
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
