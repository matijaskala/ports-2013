# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://launchpad.net/nux"
MY_PV="${PV/_p/+17.10.}"
GLEWMX="glew-1.13.0"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz
	mirror://sourceforge/glew/${GLEWMX}.tgz"

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
	default
	# Keep warnings as warnings, not failures #
	sed -e 's:-Werror ::g' \
		-i configure.ac
	sed \
		-e '/glew.lib.mx:/s|lib/$(LIB.SHARED.MX) ||' \
		-e "s:\(@libname@|\).*mx:-l\1${WORKDIR}/${GLEWMX}/lib/\$(LIB.STATIC.MX):" \
		-i ${WORKDIR}/${GLEWMX}/Makefile || die
	eautoreconf
}

src_configure() {
	emake -C ${WORKDIR}/${GLEWMX} glew.lib.mx AR="$(tc-getAR)" STRIP=true CC="$(tc-getCC)" POPT="${CFLAGS}"
	CXXFLAGS+=" -I${WORKDIR}/${GLEWMX}/include"
	PKG_CONFIG_PATH="${WORKDIR}/${GLEWMX}"

	! use test && \
		myconf="${myconf}
			--enable-tests=no
			--enable-gputests=no"
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${ED}" install || die
	sed -i 's:glewmx ::' "${ED}"/usr/$(get_libdir)/pkgconfig/* || die
	dosym /usr/libexec/nux/unity_support_test /usr/$(get_libdir)/nux/unity_support_test

	prune_libtool_files --modules
}
