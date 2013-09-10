# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
MATE_LA_PUNT="yes"

PYTHON_DEPEND="python? 2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit mate python

DESCRIPTION="The MATE menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug +introspection python"

RDEPEND=">=dev-libs/glib-2.18
	python? ( dev-python/pygtk )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=mate-base/mate-common-1.5.0
	>=dev-util/intltool-0.40"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	G2CONF="${G2CONF}
		$(use_enable python)
		$(use_enable introspection)"

	use python && python_pkg_setup
}

src_prepare() {
	mate_src_prepare
	if use python; then
		python_clean_py-compile_files
		python_copy_sources
	fi
}

src_configure() {
	if use python; then
		python_execute_function -s mate_src_configure
	else
		mate_src_configure
	fi
}

src_compile() {
	if use python; then
		python_execute_function -s mate_src_compile
	else
		mate_src_compile
	fi
}

src_test() {
	if use python; then
		python_execute_function -s -d
	else
		default
	fi
}

src_install() {
	if use python; then
		python_execute_function -s mate_src_install
		python_clean_installation_image
	else
		mate_src_install
	fi

	exeinto /etc/X11/xinit/xinitrc.d/
	# TODO: check xdg
	doexe "${FILESDIR}/10-xdg-menu-mate"
}
