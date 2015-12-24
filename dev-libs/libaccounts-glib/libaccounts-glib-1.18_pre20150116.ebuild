# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

URELEASE="wily"
inherit autotools flag-o-matic python-r1

DESCRIPTION="Library for single signon for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
MY_PV="${PV/_pre/+15.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0/0.1.3"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="dev-db/sqlite:3
	>=dev-libs/check-0.9.10
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/libxml2
	dev-util/gtk-doc
	${PYTHON_DEPS}"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	eautoreconf
	append-cflags -Wno-error
}

src_configure() {
	python_copy_sources
	configuration() {
		econf --disable-wal \
			$(use_enable debug) || die
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		emake || die
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install
	}
	python_foreach_impl run_in_build_dir installation

	rm -rf "${D}usr/doc"
	prune_libtool_files --modules
}
