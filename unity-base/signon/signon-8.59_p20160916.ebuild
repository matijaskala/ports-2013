# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="https://launchpad.net/signon"
MY_PV="${PV/_p/+16.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug doc test"
S=${WORKDIR}
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtxml:5
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )"

src_prepare() {
	default
	# Fix remotepluginprocess.cpp missing QDebug include on some systems #
	epatch "${FILESDIR}/remotepluginprocess-QDebug-fix.patch"

	# Let portage strip the files #
	sed -e 's:CONFIG         +=:CONFIG += nostrip:g' -i "${S}/common-project-config.pri" || die

	use debug && \
		for file in $(grep -r debug * | grep \\.pro | awk -F: '{print $1}' | uniq); do
			sed -e 's:CONFIG -= debug_and_release:CONFIG += debug_and_release:g' \
				-i "${file}"
		done
	use doc || \
		for file in $(grep -r doc/doc.pri * | grep \\.pro | awk -F: '{print $1}'); do
			sed -e '/doc\/doc.pri/d' -i "${file}"
		done
	use test || \
		sed -e 's:tests::g' \
			-i signon.pro
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
