# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_{6,7} )

inherit eutils mate python-single-r1

DESCRIPTION="Python bindings for the Caja file manager"
HOMEPAGE="http://www.mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

# Depend on pygobject:3 for sanity, and because it's automagic
RDEPEND="dev-python/pygobject:3[${PYTHON_USEDEP}]
	mate-base/mate-file-manager[introspection]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	#epatch "${FILESDIR}/${PN}-1.6.0-link-issue-fix.patch"
	#mate_gen_build_system
	gnome2_src_prepare
}
src_install() {
	gnome2_src_install
	# Directory for systemwide extensions
	keepdir /usr/share/python-caja/extensions/
	# Doesn't get installed by "make install" for some reason
	if use doc; then
		insinto /usr/share/gtk-doc/html/nautilus-python # for dev-util/devhelp
		doins -r docs/html/*
	fi
}
