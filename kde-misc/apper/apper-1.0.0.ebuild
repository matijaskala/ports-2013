# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="KDE Plasma PackageKit frontend"
HOMEPAGE="https://projects.kde.org/projects/extragear/sysadmin/apper"

LICENSE="GPL-2"
IUSE=""
RESTRICT="mirror"
if [[ ${KDE_BUILD_TYPE} = release ]] ; then
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
fi

DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep solid)
	$(add_plasma_dep plasma-workspace)
	$(add_qt_dep qtcore)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxmlpatterns)
	>=app-admin/packagekit-qt-0.9.6
"
RDEPEND="${DEPEND}
	!kde-misc/apper:4
"

PATCHES=( "${FILESDIR}/${P}.patch" )

src_configure() {
	local mycmakeargs=(
		-DDEBCONF_SUPPORT=OFF
		-DAUTOREMOVE=OFF
		-DAPPSTREAM=OFF
		-DLIMBA=OFF
		-DMAINTAINER=OFF
	)

	kde5_src_configure
}
