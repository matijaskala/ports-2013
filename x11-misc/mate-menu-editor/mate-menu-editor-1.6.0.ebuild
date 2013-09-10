# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="xml"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit mate python

DESCRIPTION="Mozo menu editor for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

COMMON_DEPEND="dev-python/pygobject:2
	>=mate-base/mate-menus-1.2.0[introspection,python]"

	# mate-panel needed for mate-desktop-item-edit
RDEPEND="${COMMON_DEPEND}
	>=mate-base/mate-panel-1.2.1
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:2[introspection]"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	python_pkg_setup
}

src_prepare() {
	mate_src_prepare

	# Disable pyc compiling
	python_clean_py-compile_files

	python_copy_sources
}

src_configure() {
	configure() {
		G2CONF="${G2CONF} PYTHON=$(PYTHON -a)"
		mate_src_configure
	}
	python_execute_function -s configure
}

src_compile() {
	python_execute_function -s mate_src_compile
}

src_test() {
	python_execute_function -s -d
}

src_install() {
	python_execute_function -s mate_src_install
	python_clean_installation_image
	python_convert_shebangs -r 2 "${ED}"
}

pkg_postinst() {
	mate_pkg_postinst
	python_mod_optimize Mozo
}

pkg_postrm() {
	mate_pkg_postrm
	python_mod_cleanup Mozo
}
