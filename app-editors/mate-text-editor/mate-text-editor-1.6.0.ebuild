# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"
PYTHON_DEPEND="python? 2:2.5"

inherit mate multilib python

DESCRIPTION="Pluma text editor for the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="python spell"

RDEPEND=">=x11-libs/libSM-1.0
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.23.1:2
	>=x11-libs/gtk+-2.19.0:2
	>=x11-libs/gtksourceview-2.9.7:2.0
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35
	)
	python? (
		>=dev-python/pygobject-2.15.4:2
		>=dev-python/pygtk-2.12:2
		>=dev-python/pygtksourceview-2.9.2:2
	)"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	>=app-text/scrollkeeper-0.3.11
	app-text/mate-doc-utils
	~app-text/docbook-xml-dtd-4.1.2
	>=mate-base/mate-common-1.2.2"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-updater
		$(use_enable python)
		$(use_enable spell)"
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	mate_src_prepare
	use python && python_clean_py-compile_files
}

pkg_postinst() {
	mate_pkg_postinst
	use python && python_mod_optimize /usr/$(get_libdir)/pluma/plugins
}

pkg_postrm() {
	mate_pkg_postrm
	use python && python_mod_cleanup /usr/$(get_libdir)/pluma/plugins
}
