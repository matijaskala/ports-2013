# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_5,3_6} )

inherit autotools eutils python-r1

DESCRIPTION="An implementation of the GEIS (Gesture Engine Interface and Support) interface"
HOMEPAGE="https://launchpad.net/geis"
MY_PV="${PV/_p/+16.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="unity-base/grail
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_prepare() {
	default
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
