# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker xdg

DESCRIPTION="A smarter, faster web browser"
HOMEPAGE="https://minbrowser.github.io/min/"
SRC_URI_BASE="https://github.com/minbrowser/min/releases/download/v${PV}"
SRC_URI="
	amd64? ( ${SRC_URI_BASE}/min_${PV}_amd64.deb )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip mirror"

RDEPEND="
	dev-libs/atk
	dev-libs/glib
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXScrnSaver
	x11-libs/pango
"
QA_PREBUILT="usr/lib/min/min"
S=${WORKDIR}

src_install() {
	mv * "${D}" || die
}
