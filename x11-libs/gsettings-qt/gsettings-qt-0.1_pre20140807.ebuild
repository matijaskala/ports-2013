# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VIRTUALX_REQUIRED="always"

inherit qt5-build virtualx

DESCRIPTION="Qml bindings for GSettings."
HOMEPAGE="https://launchpad.net/gsettings-qt"
MY_PV="${PV/_pre/+14.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	>=dev-libs/glib-2.38.1"

QT5_BUILD_DIR="${S}"

src_prepare() {
	qt5-build_src_prepare

	# Don't pre-strip
	echo "CONFIG+=nostrip" >> "${S}"/GSettings/gsettings-qt.pro
	echo "CONFIG+=nostrip" >> "${S}"/src/gsettings-qt.pro
	echo "CONFIG+=nostrip" >> "${S}"/tests/tests.pro

	if ! use test; then
		# remove from build
		sed -e 's:tests\/tests.pro: :g' \
			-i "${S}"/gsettings-qt.pro
	fi

}

src_install() {
	# Needs to be run in a virtual Xserver so that qmlplugindump's #
	#       qmltypes generation can successfully spawn dbus #
	pushd ${QT5_BUILD_DIR}
		Xemake INSTALL_ROOT="${ED}" install
	popd
}
