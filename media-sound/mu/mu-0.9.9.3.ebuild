# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils xdg

DESCRIPTION="An open-source music manager"
HOMEPAGE="https://kreogist.github.io/Mu"
SRC_URI="https://github.com/Kreogist/Mu/archive/${PV}.tar.gz -> Mu-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtqml:5
	dev-qt/qtnetwork:5
	media-libs/gstreamer:1.0
	virtual/ffmpeg"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/Mu-${PV}

PATCHES=( "${FILESDIR}"/disable-optimizations.patch )

src_configure() {
	eqmake5
}

src_install() {
	dobin bin/mu
	insinto /usr/share/applications
	doins debian/mu.desktop
	insinto /usr/share/pixmaps
	doins src/resource/icon/mu.png
}
