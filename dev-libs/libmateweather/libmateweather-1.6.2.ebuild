# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"
PYTHON_COMPAT=( python2_{6,7} )

inherit mate python-r1

DESCRIPTION="MATE library to access weather information from online services"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# libsoup-gnome is to be used because libsoup[gnome] might not
# get libsoup-gnome installed by the time ${P} is built
RDEPEND="x11-libs/gtk+:2
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
	>=mate-base/mate-common-1.5.0
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-locations-compression
		--disable-all-translations-in-one-xml
		$(use_enable python)"

	python_setup
}

src_prepare() {
	# fix python automagic in configure.in
	epatch "${FILESDIR}/${PN}-1.5.0-fix-automagic-python-support.patch"
	# fix undefined use of MKDIR_P in python/Makefile.am
	epatch "${FILESDIR}/${PN}-1.6.1-fix-mkdirp.patch"
	eautoreconf

	python_copy_sources
	python_foreach_impl run_in_build_dir mate_src_prepare
}

src_configure() {
	python_foreach_impl run_in_build_dir mate_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir mate_src_compile
}

src_install() {
	python_foreach_impl run_in_build_dir mate_src_install
}
