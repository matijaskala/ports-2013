# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools base ubuntu

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://launchpad.net/nux"

LICENSE="GPL-3 LGPL-3"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="media-libs/glew:=
	app-i18n/ibus
	dev-libs/boost
	>=dev-libs/glib-2.32.3
	dev-libs/libpcre
	dev-libs/libsigc++:2
	gnome-base/gnome-common
	media-libs/glew
	media-libs/libpng:0
	sys-apps/pciutils
	unity-base/geis
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXxf86vm
	x11-libs/pango
	x11-proto/dri2proto
	x11-proto/glproto"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.7
	dev-cpp/gmock
	dev-cpp/gtest"

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dosym /usr/libexec/nux/unity_support_test /usr/lib/nux/unity_support_test

	prune_libtool_files --modules
}
