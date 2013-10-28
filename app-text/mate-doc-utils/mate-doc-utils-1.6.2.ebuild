# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython *-pypy-*"

inherit multilib python mate

DESCRIPTION="Documentation utilities for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=app-text/gnome-doc-utils-0.20.10
	>=dev-libs/libxml2-2.6.12[python]
	>=dev-libs/libxslt-1.1.8"

DEPEND="${RDEPEND}
	>=sys-apps/gawk-3
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	app-text/docbook-xml-dtd:4.4
	app-text/scrollkeeper-dtd
	app-text/rarian
	>=mate-base/mate-common-1.5.0"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	python_pkg_setup
}

src_prepare() {
	mate_src_prepare
	python_clean_py-compile_files
	python_copy_sources
}

src_configure() {
	python_execute_function -s mate_src_configure
}

src_compile() {
	python_execute_function -d -s
}

src_test() {
	python_execute_function -d -s
}

src_install() {
	python_execute_function -s mate_src_install
	python_clean_installation_image

	# remove xml2po, already provided by gnome-doc-utils
	rm -rf "${ED}"usr/$(get_libdir)/python*/site-packages/xml2po || die
	rm -rf "${ED}"usr/bin/xml2po || die
	rm -rf "${ED}"usr/share/man/man*/xml2po* || die
	rm -rf "${ED}"usr/share/pkgconfig/xml2po* || die
	rm -rf "${ED}"usr/share/xml/mallard/*/mallard.{rnc,rng} || die
}
