# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic virtualx multilib-minimal

DESCRIPTION="A set of symbols and convenience functions that all indicators would like to use"
HOMEPAGE="https://launchpad.net/libindicator"
MY_PV=${PV/_p/+16.10.}
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
S=${WORKDIR}
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.37[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	test? ( dev-util/dbus-test-runner )"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	append-flags -Wno-error

	myconf=(
		--disable-silent-rules
		--disable-static
		--with-gtk=2
	)
	local ECONF_SOURCE=${S}
	econf "${myconf[@]}"
}

multilib_src_test() {
	Xemake check #391179
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	rm -vf \
		"${ED}"/usr/lib*/libdummy-indicator-* \
		"${ED}"/usr/lib/systemd/user/indicators-pre.target \
		"${ED}"/usr/share/${PN}/*indicator-debugging
}
