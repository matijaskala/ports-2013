# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit base cmake-utils distutils-r1 eutils gnome2 pam toolchain-funcs

DESCRIPTION="The Ubuntu Unity Desktop"
HOMEPAGE="https://launchpad.net/unity"
MY_PV="${PV/_pre/+16.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"
SRC_URI="https://launchpad.net/${PN}/7.3/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc pch test"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

COMMONDEPEND="
	dev-libs/dee:=
	dev-libs/libdbusmenu:=
	dev-libs/libindicator:3=
	dev-libs/libunity-misc:=
	dev-libs/xpathselect
	gnome-base/gnome-desktop:3=
	gnome-base/gnome-session
	gnome-base/gsettings-desktop-schemas
	gnome-extra/zeitgeist
	media-libs/glew:=
	sys-apps/upstart
	sys-auth/pambase
	unity-base/compiz:=
	unity-base/dconf-qt
	unity-base/nux:=
	unity-base/overlay-scrollbar
	unity-base/unity-gtk-module
	virtual/pam
	x11-libs/bamf:=
	>=x11-libs/cairo-1.13.1
	x11-libs/libXfixes
	x11-libs/startup-notification
"
RDEPEND="$COMMONDEPEND
	unity-base/unity-control-center
	unity-base/unity-settings-daemon
	unity-base/gsettings-ubuntu-touch-schemas
	unity-base/unity-language-pack
	x11-misc/appmenu-qt
	x11-misc/appmenu-qt5
	x11-themes/humanity-icon-theme
	x11-themes/gtk-engines-murrine
	x11-themes/unity-asset-pool
"
DEPEND="$COMMONDEPEND
	dev-libs/boost:=
	dev-libs/libappindicator
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libindicate-qt
	app-text/yelp-tools
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/gmock
		dev-cpp/gtest
		dev-python/autopilot
		dev-util/dbus-test-runner
		sys-apps/xorg-gtest )"

src_prepare() {
	if use test; then
		## Disable source trying to run it's own dummy-xorg-test-runner.sh script ##
		sed -e 's:set (DUMMY_XORG_TEST_RUNNER.*:set (DUMMY_XORG_TEST_RUNNER /bin/true):g' \
			-i tests/CMakeLists.txt
	else
		PATCHES+=( "${FILESDIR}/unity-7.1.0_remove-gtest-dep.diff" )
	fi


	# Taken from http://ppa.launchpad.net/timekiller/unity-systrayfix/ubuntu/pool/main/u/unity/ #
	epatch -p1 "${FILESDIR}/systray-fix_saucy.diff"

	base_src_prepare

	# Setup Unity side launcher default applications #
	sed \
		-e '/amazon/d' \
		-e '/software-center/d' \
		-e 's:nautilus.desktop:org.gnome.Nautilus.desktop:' \
			-i com.canonical.Unity.gschema.xml || die

	sed -e "s:/desktop:/org/unity/desktop:g" \
		-i com.canonical.Unity.gschema.xml || die

	sed -e "s:Ubuntu Desktop:Unity Gentoo Desktop:g" \
		-i panel/PanelMenuView.cpp || die

	# Remove testsuite cmake installation #
	sed -e '/python setup.py install/d' \
			-i tests/CMakeLists.txt

	# Unset CMAKE_BUILD_TYPE env variable so that cmake-utils.eclass doesn't try to 'append-cppflags -DNDEBUG' #
	#       resulting in build failure with 'fatal error: unitycore_pch.hh: No such file or directory' #
	export CMAKE_BUILD_TYPE=none

	# Disable '-Werror'
	sed -i 's/[ ]*-Werror[ ]*//g' CMakeLists.txt services/CMakeLists.txt

	# Support use of the /usr/bin/unity python script #
	sed \
		-e 's:.*"stop", "unity-panel-service".*:        subprocess.call(["pkill -e unity-panel-service"], shell=True):' \
		-e 's:.*"start", "unity-panel-service".*:        subprocess.call(["/usr/lib/unity/unity-panel-service"], shell=True):' \
			-i tools/unity.cmake

	# Don't kill -9 unity-panel-service when launched using PANEL_USE_LOCAL_SERVICE env variable #
	#  It slows down the launch of unity-panel-service in lockscreen mode #
	sed -e '/killall -9 unity-panel-service/,+1d' \
		-i UnityCore/DBusIndicators.cpp

	# Include directly iostream needed for std::cout #
	sed -e 's/.*<fstream>.*/#include <iostream>\n&/' \
		-i unity-shared/DebugDBusInterface.cpp
}

src_configure() {
	if use test; then
		mycmakeargs="${mycmakeargs}
			-DBUILD_XORG_GTEST=ON
			-DCOMPIZ_BUILD_TESTING=ON"
	else
		mycmakeargs="${mycmakeargs}
			-DBUILD_XORG_GTEST=OFF
			-DCOMPIZ_BUILD_TESTING=OFF"
	fi

	if use pch; then
		mycmakeargs="${mycmakeargs} -Duse_pch=ON"
	else
		mycmakeargs="${mycmakeargs} -Duse_pch=OFF"
	fi

	mycmakeargs="${mycmakeargs}
		-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DCOMPIZ_PLUGIN_INSTALL_TYPE=package
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR=/etc/gconf/schemas
		-DUSE_GSETTINGS=TRUE
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_SYSCONFDIR=/etc"
	cmake-utils_src_configure || die
}

src_compile() {
	if use test; then
		pushd tests/autopilot
			distutils-r1_src_compile
		popd
	fi
	cmake-utils_src_compile || die
}

src_test() {
	pushd ${CMAKE_BUILD_DIR}
		make check-headless
	popd
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
		addpredict /usr/share/glib-2.0/schemas/	# FIXME
		emake DESTDIR="${D}" install
	popd

	if use debug; then
		exeinto /etc/X11/xinit/xinitrc.d/
		doexe "${FILESDIR}/99unity-debug"
	fi

	if use test; then
		pushd tests/autopilot
			distutils-r1_src_install
		popd
	fi

	python_fix_shebang "${ED}"

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Remove upstart jobs as we use xsession based scripts in /etc/X11/xinit/xinitrc.d/ #
	rm -rf "${ED}usr/share/upstart"

	insinto /etc/xdg/autostart
	doins "${FILESDIR}/unity-panel-service.desktop"

	insinto /usr/share/dbus-1/services/
	doins "${FILESDIR}/com.canonical.Unity.Panel.Service.Desktop.service"
	doins "${FILESDIR}/com.canonical.Unity.Panel.Service.LockScreen.service"

	# Allow zeitgeist-fts to find KDE *.desktop files, so that KDE applications show in Dash 'Recently Used' #
	#  (refer https://developer.gnome.org/gio/2.33/gio-Desktop-file-based-GAppInfo.html#g-desktop-app-info-new)
	dosym /usr/share/applications/kde4/ /usr/share/kde4/applications
	insinto /etc/X11/xinit/xinitrc.d
	doins "${FILESDIR}/15-xdg-data-kde"

	# Clean up pam file installation as used in lockscreen (LP# 1305440) #
	rm "${ED}etc/pam.d/${PN}"
	pamd_mimic system-local-login ${PN} auth account session
}

pkg_postinst() {
	elog
	elog "If you use a custom ~/.xinitrc to startx"
	elog "then you should add the following to the top of your ~/.xinitrc file"
	elog "to ensure all needed services are started:"
	elog ' XSESSION=unity'
	elog ' if [ -d /etc/X11/xinit/xinitrc.d ] ; then'
	elog '   for f in /etc/X11/xinit/xinitrc.d/* ; do'
	elog '     [ -x "$f" ] && . "$f"'
	elog '   done'
	elog ' unset f'
	elog ' fi'
	elog
	elog "It is recommended to enable the 'ayatana' USE flag"
	elog "for portage packages so they can use the Unity"
	elog "libindicate or libappindicator notification plugins"
	elog
	elog "If you would like to use Unity's icons and themes"
	elog "select the Ambiance theme in 'System Settings > Appearance'"
	elog

	if use test; then
		elog "To run autopilot tests, do the following:"
		elog "cd /usr/$(get_libdir)/${EPYTHON}/site-packages/unity/tests"
		elog "and run 'autopilot run unity'"
		elog
	fi

	gnome2_pkg_postinst
}
