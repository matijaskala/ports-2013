# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils games qt4-r2

DESCRIPTION="Qt4 GUI frontend for NSRT"
HOMEPAGE="http://snesemu.black-ship.net/index.php?page=tools"
SRC_URI="http://7clams.org/flora/distfiles/nf-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="$(printf 'linguas_%s ' de es fr he it ja nl)"
RESTRICT="mirror"

DEPEND=">=dev-qt/qtcore-4.2
	>=dev-qt/qtgui-4.2"

RDEPEND="games-util/nsrt-bin"

MAKEOPTS+=" -j1"

S="${WORKDIR}"/"nf-${PV}"/source
LANGDIR="${GAMES_DATADIR}"/"nf"/lang

src_prepare() {
	sed -i -e "s/-O1/-O1 -D_FORTIFY_SOURCE=0/" conf/Makefile || die
	sed -i -e "s/include <string>/include <string.h>/" conf/parsegen.cpp || die
	sed -i -e "s:(QString(\"lang/\"):(QString(\"${LANGDIR}/\"):" main.cpp || die
	sed -i -e "s/qApp->applicationDirPath() + QDir::separator() + \"/QDir::homePath() + \"\/\.config\//" globals.cpp || die
}

src_compile() {
	emake || die
}

src_install() {
	dogamesbin nf || die
	newicon res/nficonvl.png nf.png
	make_desktop_entry "nf" "NSRT Frontend" "nf" "Utility;FileTools;Qt" "Comment=${DESCRIPTION}"
	dodoc ../docs/nf.txt
	insinto "${LANGDIR}"
	for h in de es fr he it ja nl; do
		if use linguas_"${h}"; then
			doins lang/"${h}".*
		fi
	done

	prepgamesdirs
}
