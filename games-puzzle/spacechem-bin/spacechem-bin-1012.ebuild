# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games eutils

DESCRIPTION="A design-based puzzle game from Zachtronics Industries"
HOMEPAGE="http://spacechemthegame.com/"
SRC_URI="!hib? ( SpaceChem-${PV}.tar.gz ) hib? ( SpaceChem-${PV}-1-hib.tar.gz )"

LICENSE="SPACECHEM"
SLOT="0"
KEYWORDS="-* x86 amd64"
IUSE="hib"
RESTRICT="fetch strip"

RDEPEND=">=dev-lang/mono-2
	x11-misc/xclip
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
		amd64? (
			app-emulation/emul-linux-x86-sdl
		)"

S=${WORKDIR}

pkg_nofetch() {
	if use !hib; then
		elog "Fetch SpaceChem-${PV}.tar.gz and move or link it"
		elog "to ${DISTDIR}. If this is your first time installing SpaceChem,"
		elog "be sure to have your license key close by as the game will"
		elog "will ask for it when started for the first time."
		elog
		elog "If you have obtained SpaceChem from one of the Humble Indie"
		elog "Bundles, enable the \"hib\" use flag for this package and fetch"
		elog "SpaceChem-${PV}-1-hib.tar.gz. You will not need to enter a key."
		elog "Copy and paste for the lazy:"
		elog "# echo ${CATEGORY}/${PN} hib >> /etc/portage/package.use"
		elog
		elog "Purchase the game from http://spacechemthegame.com/"
	else
		elog "Fetch SpaceChem-${PV}-1-hib.tar.gz and move or link it"
		elog "to ${DISTDIR}."
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	unpack ./SpaceChem-i386.deb
	unpack ./data.tar.gz
}

src_install() {
	mv ${S}/opt ${D}
	cd ${D}/opt/zachtronicsindustries/spacechem
	chmod +x spacechem-launcher.sh
	dodoc readme/PRIVACY.txt readme/SOUND-CREDITS.txt
	domenu zachtronicsindustries-spacechem.desktop
	rm -r readme zachtronicsindustries-spacechem.desktop
	newicon icon.png zachtronicsindustries-spacechem.png

	prepgamesdirs
}
