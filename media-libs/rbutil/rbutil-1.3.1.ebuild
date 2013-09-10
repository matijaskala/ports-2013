# Distributed under the terms of the GNU General Public License v2

EAPI=4
LANGS="cs de fi fr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit eutils qt4-r2

MY_P=RockboxUtility-v${PV}

DESCRIPTION="Rockbox opensource firmware manager for mp3 players"
HOMEPAGE="http://www.rockbox.org/wiki/RockboxUtility"
SRC_URI="http://download.rockbox.org/${PN}/source/${MY_P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="media-libs/speex
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	virtual/libusb:0"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}/${PN}/${PN}qt

src_configure() {
	# generate binary translations
	lrelease ${PN}qt.pro || die

	# noccache is required in order to call the correct compiler
	eqmake4 CONFIG+=noccache
}

src_install() {
	newbin RockboxUtility ${PN} || die
	newicon icons/rockbox-48.png ${PN}.png || die
	make_desktop_entry ${PN} "Rockbox Utility"
}
