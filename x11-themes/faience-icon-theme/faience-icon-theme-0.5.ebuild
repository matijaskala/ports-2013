EAPI=4
inherit gnome2-utils

MP_P=${PN}_${PV}

DESCRIPTION="A scalable icon theme called Faience"
HOMEPAGE="http://tiheum.deviantart.com/art/Faience-icon-theme-255099649"
SRC_URI="http://faience-theme.googlecode.com/files/faience-icon-theme_0.5.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

REDEPEND="!minimal? ( x11-themes/gnome-icon-theme )
		x11-themes/hicolor-icon-theme"
DEPEND="app-arch/tar
		app-arch/gzip"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_prepare() {
	cd ${WORKDIR}
	for x in Faience Faience-Azur Faience-Claire Faience-Ocre; do
		tar xf "${x}".tar.gz
	done
}

src_install() {
	dodir /usr/share/icons
	insinto /usr/share/icons
	doins -r "${S}"/Faience || die "Installing icons failed!"
	doins -r "${S}"/Faience* || die "Installing icons failed!"
}
