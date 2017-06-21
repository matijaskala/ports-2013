# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Qt5 bindings for libaccounts-glib"
HOMEPAGE="https://gitlab.com/p/accounts-sso/libaccounts-qt"
MY_PV="${PV/_p/+17.04.}.1"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/lib${PN}_${MY_PV}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc test"

S=${WORKDIR}
RESTRICT="mirror"

RDEPEND="
	net-libs/libaccounts-glib:=
	dev-qt/qtcore:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )
"

src_prepare() {
	default
	use doc || \
		for file in $(grep -r doc/doc.pri * | grep .pro | awk -F: '{print $1}'); do
			sed -e '/doc\/doc.pri/d' -i "${file}"
		done
	use test || sed -i -e '/^SUBDIRS/s/tests//' accounts-qt.pro || die "couldn't disable tests"
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
