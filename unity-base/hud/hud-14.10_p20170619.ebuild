# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit cmake-utils distutils-r1 flag-o-matic gnome2-utils vala

DESCRIPTION="Backend for the Unity HUD"
HOMEPAGE="https://launchpad.net/hud"
MY_PV="${PV/_p/+17.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

RDEPEND="
	dev-libs/libdbusmenu-qt
	x11-libs/dee-qt[qt5(+)]
	x11-libs/gtk+:3
"
DEPEND="
	dev-db/sqlite:3
	dev-libs/dee[${PYTHON_USEDEP}]
	dev-libs/glib:2[${PYTHON_USEDEP}]
	dev-libs/libdbusmenu:=
	dev-libs/libdbusmenu-qt
	dev-libs/libqtdbusmock
	dev-perl/XML-Parser
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtwidgets:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	gnome-base/dconf
	sys-libs/libnih[dbus]
	x11-libs/bamf:=
	x11-libs/dee-qt[qt5(+)]
	x11-libs/gsettings-qt
	x11-libs/gtk+:3
	x11-libs/pango
	$(vala_depend)
	test? ( dev-util/dbus-test-runner )"

src_prepare() {
	vala_src_prepare

	sed -e 's/SESSION=ubuntu)/SESSION=unity)/g' \
		-i data/hud.conf.in

	# Stop cmake doing the job of distutils #
	sed -e '/add_subdirectory(hudkeywords)/d' \
		-i tools/CMakeLists.txt

	# disable build of tests
	sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die

	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=( -DENABLE_TESTS="$(usex test)"
			-DENABLE_DOCUMENTATION="$(usex doc)"
			-DENABLE_BAMF=ON
			-DVALA_COMPILER=${VALAC}
			-DVAPI_GEN=${VAPIGEN}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	pushd tools/hudkeywords
		distutils-r1_src_compile
	popd
}

src_install() {
	cmake-utils_src_install
	pushd tools/hudkeywords
		distutils-r1_src_install
		python_fix_shebang "${ED}"
	popd
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
