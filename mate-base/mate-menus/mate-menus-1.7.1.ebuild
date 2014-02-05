# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

PYTHON_COMPAT=( python2_{6,7} )

inherit mate python-r1

DESCRIPTION="The MATE menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug +introspection python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.18
	python? ( dev-python/pygtk[${PYTHON_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=mate-base/mate-common-1.5.0
	>=dev-util/intltool-0.40"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	G2CONF="${G2CONF} \
		$(use_enable python) \
		$(use_enable introspection)"

	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	if use python; then
		python_copy_sources
		python_foreach_impl run_in_build_dir gnome2_src_configure
	else
		gnome2_src_configure
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir gnome2_src_compile
	else
		gnome2_src_compile
	fi
}

src_test() {
	if use python; then
		python_foreach_impl run_in_build_dir emake check
	else
		emake check
	fi
}

src_install() {
	if use python; then
		python_foreach_impl run_in_build_dir gnome2_src_install
	else
		gnome2_src_install
	fi

	exeinto /etc/X11/xinit/xinitrc.d/
	# TODO: check xdg
	doexe "${FILESDIR}/10-xdg-menu-mate"
}
