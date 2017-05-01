# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://launchpad.net/nux"
MY_PV="${PV/_p/+16.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE="test"
S=${WORKDIR}
RESTRICT="mirror"

RDEPEND="app-i18n/ibus
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/libsigc++:2
	gnome-base/gnome-common
	<media-libs/glew-2.0.0:=
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
	test? ( dev-cpp/gmock
		dev-cpp/gtest )"

src_prepare() {
	eautoreconf
}

src_configure() {
	! use test && \
		myconf="${myconf}
			--enable-tests=no
			--enable-gputests=no"
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	prune_libtool_files --modules
}
