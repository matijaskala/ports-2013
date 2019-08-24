# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils vala

VALA_PANEL_APPMENU_VER="0.7.3"

DESCRIPTION="Lightweight desktop panel"
HOMEPAGE="https://github.com/rilian-la-te/vala-panel"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/${PN}/${PV}+dfsg1-1/${PN}_${PV}+dfsg1.orig.tar.xz
	https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/${PN}-appmenu/${VALA_PANEL_APPMENU_VER}+dfsg1-1/${PN}-appmenu_${VALA_PANEL_APPMENU_VER}+dfsg1.orig.tar.xz"

LICENSE="LGPL-3"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="+wnck"
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-3.22.0:3[wayland,X]
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=dev-libs/libpeas-1.2.0
	wnck? ( >=x11-libs/libwnck-3.4.0:3 )"
DEPEND="${RDEPEND}
	dev-util/cmake-vala
	dev-lang/vala
	virtual/pkgconfig
	sys-devel/gettext
	$(vala_depend)"

GNOME2_ECLASS_GLIB_SCHEMAS="org.valapanel.gschema.xml"

src_prepare() {
	mkdir ${S}/cmake
	cp -rfv ${WORKDIR}/vala-panel-appmenu-${VALA_PANEL_APPMENU_VER}/cmake/*.cmake ${S}/cmake
	vala_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_WNCK=$(usex wnck)
		-DGSETTINGS_COMPILE=OFF
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_schemas_update
}
