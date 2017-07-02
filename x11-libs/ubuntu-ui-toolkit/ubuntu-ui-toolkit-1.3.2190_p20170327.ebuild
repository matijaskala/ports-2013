# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils virtualx

DESCRIPTION="Qt Components for the Unity desktop - QML plugin"
HOMEPAGE="https://launchpad.net/ubuntu-ui-toolkit"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+17.04.}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="mirror"

RDEPEND="dev-qt/qtfeedback:5
	x11-libs/unity-action-api"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtpim:5
	dev-qt/qtsvg:5
	dev-qt/qttest:5
	media-gfx/thumbnailer
	doc? ( dev-qt/qdoc:5 )"

S="${WORKDIR}"
unset QT_QPA_PLATFORMTHEME

src_prepare() {
	export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qdoc

	use doc || \
		sed -e '/documentation.pri/d' \
			-e 's:po documentation:po :g' \
			-i ubuntu-sdk.pro

	# Don't install autopilot python testsuite files, they require dpkg to run tests #
	sed -e '/autopilot/d' \
		-i tests/tests.pro

	default
}

src_configure() {
	eqmake5
}

src_test() {
	Xemake check	# Currently fails with 'tst_headActions.qml exited with 666' #
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
	use examples || \
		rm -rf "${ED}usr/lib/ubuntu-ui-toolkit/examples" \
			"${ED}usr/share/applications"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
