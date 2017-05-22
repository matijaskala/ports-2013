# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="QT library for Single Sign On framework for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
MY_PV="${PV/_p/+17.04.}.1"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0/1.2.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

DEPEND="net-libs/libaccounts-glib:=
	dev-qt/qtcore:5
	dev-qt/qtxml:5
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )"

src_prepare() {
	default
	use doc || \
		for file in $(grep -r doc/doc.pri * | grep .pro | awk -F: '{print $1}'); do
			sed -e '/doc\/doc.pri/d' -i "${file}"
		done
	use test || \
		sed -e 's:tests::g' \
			-i accounts-qt.pro
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
