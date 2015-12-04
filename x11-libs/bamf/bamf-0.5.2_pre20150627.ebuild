# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils vala python-single-r1

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"
MY_PV="${PV/_pre/~bzr0+15.10.}.1"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/gobject-introspection
	dev-libs/libxslt[python,${PYTHON_USEDEP}]
	dev-libs/libxml2[${PYTHON_USEDEP}]
	dev-util/gdbus-codegen
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3
	x11-libs/libXfixes
	$(vala_depend)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN=$VAPIGEN

	sed -e "s:-Werror::g" \
		-i "configure.ac" || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-introspection=yes \
		--disable-static || die
}
