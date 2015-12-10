# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://launchpad.net/nux"
MY_PV="${PV/_pre/+14.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

RDEPEND="media-libs/glew:=
	app-i18n/ibus
	dev-libs/boost
	>=dev-libs/glib-2.32.3
	dev-libs/libpcre
	dev-libs/libsigc++:2
	gnome-base/gnome-common
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
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	prune_libtool_files --modules
}
