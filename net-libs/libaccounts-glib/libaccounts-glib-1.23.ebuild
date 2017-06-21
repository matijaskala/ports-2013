# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit autotools flag-o-matic python-r1 vcs-snapshot xdg-utils

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://gitlab.com/accounts-sso/libaccounts-glib"
SRC_URI="https://gitlab.com/accounts-sso/libaccounts-glib/repository/archive.tar.gz?ref=VERSION_${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/0.2.0"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
	dev-python/pygobject:3
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
"

RESTRICT="mirror test"

DOCS=( AUTHORS NEWS )

pkg_setup() {
	xdg_environment_reset
}

src_prepare() {
	default
	eautoreconf
	append-cflags -Wno-error
}

src_configure() {
	python_copy_sources
	configuration() {
		econf \
			--disable-tests \
			--disable-wal \
			$(use_enable debug)
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir emake
}

src_install() {
	python_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
