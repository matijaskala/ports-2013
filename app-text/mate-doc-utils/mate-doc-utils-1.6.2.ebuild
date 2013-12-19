# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_{6,7} )

inherit mate multilib python-r1

DESCRIPTION="Documentation utilities for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=app-text/gnome-doc-utils-0.20.10[${PYTHON_USEDEP}]
	>=dev-libs/libxml2-2.6.12[python,${PYTHON_USEDEP}]
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

src_prepare() {
	mate_src_prepare

	# Leave shebang alone
	sed -e '/s+^#!.*python.*+#/d' \
		-i xml2po/xml2po/Makefile.{am,in} || die

	python_prepare() {
		mkdir -p "${BUILD_DIR}"
	}
	python_foreach_impl python_prepare
}

src_configure() {
	ECONF_SOURCE="${S}" python_foreach_impl run_in_build_dir mate_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir mate_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir mate_src_test
}

src_install() {
	dodoc AUTHORS ChangeLog NEWS README
	python_foreach_impl run_in_build_dir mate_src_install
	
	# Uncomment the below when we stop relying on gnome-doc-utils
	#python_replicate_script "${ED}"/usr/bin/xml2po

	# remove xml2po, already provided by gnome-doc-utils
	rm -rf "${ED}"usr/$(get_libdir)/python*/site-packages/xml2po || die
	rm -rf "${ED}"usr/bin/xml2po || die
	rm -rf "${ED}"usr/share/man/man*/xml2po* || die
	rm -rf "${ED}"usr/share/pkgconfig/xml2po* || die
	rm -rf "${ED}"usr/share/xml/mallard/*/mallard.{rnc,rng} || die
}
