# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Windows-specific support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 hppa ppc ppc64 x86"
fi

IUSE=""
RESTRICT="mirror"

RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtxmlpatterns-${PV}
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtwidgets-${PV} )
"
