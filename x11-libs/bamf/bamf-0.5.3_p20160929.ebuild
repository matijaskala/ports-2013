# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils vala python-single-r1

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+16.10.}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/gobject-introspection
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	dev-libs/libxslt[python,${PYTHON_USEDEP}]
	gnome-base/libgtop:2
	>=x11-libs/libwnck-3.4.7:3
	$(vala_depend)"

DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	gnome-base/gnome-common
	virtual/pkgconfig"

S=${WORKDIR}

src_prepare() {
	eapply_user
	vala_src_prepare
	export VALA_API_GEN=$VAPIGEN

	sed -e "s:-Werror::g" \
		-i "configure.ac" || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-export-actions-menu=yes \
		--enable-introspection=yes \
		--disable-static || die
}
