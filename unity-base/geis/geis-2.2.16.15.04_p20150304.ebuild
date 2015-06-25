# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

inherit autotools eutils python-r1 ubuntu-versionator

DESCRIPTION="An implementation of the GEIS (Gesture Engine Interface and Support) interface"
HOMEPAGE="https://launchpad.net/geis"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/grail
	${PYTHON_DEPS}"

src_prepare() {
	eautoreconf
}

src_configure() {
	python_copy_sources
	configuration() {
		econf || die
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		emake || die
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install
	}
	python_foreach_impl run_in_build_dir installation
	prune_libtool_files --modules
}
