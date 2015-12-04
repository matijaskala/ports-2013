# Distributed under the terms of the GNU General Public License v2

EAPI=5
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit base gnome2 cmake-utils eutils python-r1 versionator

DESCRIPTION="OpenGL window and compositing manager"
HOMEPAGE="https://launchpad.net/compiz"

MAJOR_BRANCH=$(get_version_component_range 1-3)
MINOR_VERSION=$(get_version_component_range 4)

if [[ ${MINOR_VERSION} == 999 ]] ; then
	inherit bzr
	EBZR_REPO_URI="http://bazaar.launchpad.net/~compiz-team/compiz/${MAJOR_BRANCH}"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://launchpad.net/${PN}/${MAJOR_BRANCH}/${PV}/+download/${P}.tar.bz2"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0"
IUSE="debug kde test"
RESTRICT="mirror"

COMMONDEPEND="
	!x11-wm/compiz-fusion
	!x11-libs/compiz-bcop
	!x11-libs/libcompizconfig
	!x11-libs/compizconfig-backend-gconf
	!x11-libs/compizconfig-backend-kconfig4
	!x11-plugins/compiz-plugins-main
	!x11-plugins/compiz-plugins-extra
	!x11-plugins/compiz-plugins-unsupported
	!x11-apps/ccsm
	!dev-python/compizconfig-python
	!x11-apps/fusion-icon
	dev-libs/boost:=[${PYTHON_USEDEP}]
	dev-libs/glib:2[${PYTHON_USEDEP}]
	dev-cpp/glibmm
	dev-libs/libxml2[${PYTHON_USEDEP}]
	dev-libs/libxslt[${PYTHON_USEDEP}]
	dev-python/pyrex[${PYTHON_USEDEP}]
	gnome-base/gconf[${PYTHON_USEDEP}]
	>=gnome-base/gsettings-desktop-schemas-3.8
	>=gnome-base/librsvg-2.14.0:2
	media-libs/libpng:0=
	media-libs/mesa[gallium,llvm]
	x11-base/xorg-server
	>=x11-libs/cairo-1.0
	x11-libs/gtk+:3
	x11-libs/pango
	x11-libs/libwnck:1
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXinerama
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/startup-notification-0.7
	virtual/opengl
	virtual/glu
	>=x11-wm/metacity-3.12
	kde? ( >=kde-base/kwin-4.2.0 )
	${PYTHON_DEPS}"

DEPEND="${COMMONDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto
	test? ( dev-cpp/gtest
		dev-cpp/gmock
		sys-apps/xorg-gtest )"

RDEPEND="${COMMONDEPEND}
	x11-apps/mesa-progs
	x11-apps/xvinfo"

src_prepare() {
	base_src_prepare

	export CMAKE_BUILD_TYPE=none

	epatch "${FILESDIR}/${PN}-sandbox.patch"
	epatch "${FILESDIR}/rotate_edge.patch"
	epatch "${FILESDIR}/untest.diff"
	epatch "${FILESDIR}/gsettings_schemas.diff"

	echo "gtk/gnome/compiz-wm.desktop.in" >> "${S}/po/POTFILES.skip"
	echo "metadata/core.xml.in" >> "${S}/po/POTFILES.skip"
	python_copy_sources
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR="/etc/gconf/schemas"
		-DCOMPIZ_DISABLE_GCONF_SCHEMAS_INSTALL=TRUE
		-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DUSE_GCONF=OFF
		-DUSE_GSETTINGS=ON
		-DCOMPIZ_DISABLE_GS_SCHEMAS_INSTALL=OFF
		$(cmake-utils_use_use kde KDE4)
		$(cmake-utils_use test COMPIZ_BUILD_TESTING)
		-DCOMPIZ_DEFAULT_PLUGINS="ccp"
		-DCOMPIZ_DESTDIR=${D}
		"
	configuration() {
		cmake-utils_src_configure
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		cmake-utils_src_compile VERBOSE=1
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		pushd ${CMAKE_BUILD_DIR}
			addpredict /usr/share/glib-2.0/schemas/
			emake DESTDIR="${ED}" install

			# Window manager desktop file for GNOME #
			insinto /usr/share/gnome/wm-properties/
			doins gtk/gnome/compiz.desktop

			# Keybinding files #
			insinto /usr/share/gnome-control-center/keybindings
			doins gtk/gnome/*.xml
		popd &> /dev/null
	}
	python_foreach_impl run_in_build_dir installation
}

pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
}
