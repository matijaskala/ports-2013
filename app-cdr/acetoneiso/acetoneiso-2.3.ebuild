# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils

DESCRIPTION="a feature-rich and complete software application to manage CD/DVD images"
HOMEPAGE="https://sourceforge.net/projects/acetoneiso/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtwebkit:5
	media-libs/phonon[qt5]"
RDEPEND="${DEPEND}
	sys-fs/fuseiso"

S=${WORKDIR}/${PN}_${PV}/${PN}
DOCS=( ../{AUTHORS,CHANGELOG,FEATURES,README} )

src_prepare() {
	sed -i 's/QtGui/QtWidgets/' sources/* || die
	sed -i 's/getInteger/getInt/' sources/* || die
	sed -i 's/WFlags/WindowFlags/' sources/* || die
	sed -i 's/webkit/webkitwidgets/' ${PN}.pro || die
	sed -i "s/TARGET = /TARGET = ${PN}/" ${PN}.pro || die
	sed -i 's/QT += phonon/LIBS += -lphonon4qt5/' ${PN}.pro || die
	sed -i 's/unrar-nonfree/unrar/g' sources/compress.h locale/*.ts || die
	default
}

src_configure() {
	append-cxxflags -I/usr/include/phonon4qt5/KDE

	eqmake5
}

src_install() {
	emake install INSTALL_ROOT="${ED}"
	einstalldocs
}
