# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit autotools distutils-r1 vala

DESCRIPTION="Ubuntu mobile platform package management framework"
HOMEPAGE="https://launchpad.net/click"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.10.}.3.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls systemd"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0.8
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	$(vala_depend)"

S="${WORKDIR}"

src_prepare() {
	cat > get-version << EOF
#!/bin/sh
printf %s ${PV/_p/+17.10.}.3-0ubuntu1
EOF
	distutils-r1_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	export PYTHON_INSTALL_FLAGS="--force --no-compile --root=${ED}"
	econf \
		--disable-packagekit \
		$(use_enable nls) \
		$(use_enable systemd)
}

src_install() {
	default
	prune_libtool_files --modules
}
