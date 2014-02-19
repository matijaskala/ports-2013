# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_{6,7} )

inherit mate python-r1

DESCRIPTION="MATE library to access weather information from online services"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3 python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# libsoup-gnome is to be used because libsoup[gnome] might not
# get libsoup-gnome installed by the time ${P} is built
RDEPEND="gtk3? ( x11-libs/gtk+:2 )
	!gtk3? ( x11-libs/gtk+:3 )
	>=dev-libs/glib-2.13:2[${PYTHON_USEDEP}]
	>=net-libs/libsoup-2.42.1:2.4
	>=net-libs/libsoup-gnome-2.25.1:2.4
	>=dev-libs/libxml2-2.6.0:2
	>=sys-libs/timezone-data-2010k
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-2:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40.3
	>=mate-base/mate-common-1.7.0
	virtual/pkgconfig"

src_prepare() {
	python_copy_sources
	python_foreach_impl run_in_build_dir gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS"

	G2CONF="${G2CONF}
		--enable-locations-compression
		--disable-all-translations-in-one-xml
		$(use_enable python)"

	use gtk3 && G2CONF="${G2CONF} --with-gtk=3.0"
	use !gtk3 && G2CONF="${G2CONF} --with-gtk=2.0"

	python_foreach_impl run_in_build_dir gnome2_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_install() {
	python_foreach_impl run_in_build_dir gnome2_src_install
}
