# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit autotools base python-r1 vala

DESCRIPTION="Library for instrumenting and integrating with all aspects of the Unity shell"
HOMEPAGE="https://launchpad.net/libunity"
MY_PV=${PV/_pre/+15.10.}
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0/9.0.2"
KEYWORDS="amd64 x86"
IUSE=""
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND=">=dev-libs/dee-1.2.5:=
	dev-libs/libdbusmenu:=
	dev-libs/libgee:0
	x11-libs/gtk+:3
	${PYTHON_DEPS}
	$(vala_depend)"

RDEPEND="${DEPEND}"

src_prepare() {
	base_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
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
