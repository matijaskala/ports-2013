# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

SRC_SUFFIX="tar.xz"

inherit autotools distutils-r1 ubuntu vala

DESCRIPTION="Ubuntu mobile platform package management framework"
HOMEPAGE="https://launchpad.net/click"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls systemd"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0.8
	nls? ( virtual/libintl )
	$(vala_depend)"

src_prepare() {
	vala_src_prepare
	eautoreconf
}

src_configure() {
	distutils-r1_src_configure
	econf \
		--disable-packagekit \
		$(use_enable nls) \
		$(use_enable systemd)
}

src_compile() {
	rm -rfv tests/
	distutils-r1_src_compile
	pushd lib/
		emake
	popd
}

src_install() {
	distutils-r1_src_install
	pushd lib/
		emake DESTDIR="${ED}" install
	popd
	prune_libtool_files --modules
}
