# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic virtualx multilib-minimal

DESCRIPTION="A set of symbols and convenience functions that all indicators would like to use"
HOMEPAGE="https://launchpad.net/libindicator"
MY_PV=${PV/_pre/+16.04.}
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="test"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.22[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	unity-indicators/ido
	test? ( dev-util/dbus-test-runner )"

src_prepare() {
	eautoreconf
}

multilib_src_configure() {
	append-flags -Wno-error

	myconf=(
		--disable-silent-rules
		--disable-static
		--with-gtk=3
	)
	local ECONF_SOURCE=${S}
	econf "${myconf[@]}"
}

multilib_src_test() {
	Xemake check #391179
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all
}
