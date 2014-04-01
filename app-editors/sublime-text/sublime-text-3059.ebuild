# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils

MY_PN="sublime_text_3"
S="${WORKDIR}/${MY_PN}"

DESCRIPTION="Sublime Text is a sophisticated text editor for code, html and prose"
HOMEPAGE="http://www.sublimetext.com"
COMMON_URI="http://c758482.r82.cf2.rackcdn.com/${MY_PN}_build_${PV}"
SRC_URI="amd64? ( ${COMMON_URI}_x64.tar.bz2 )
	x86? ( ${COMMON_URI}_x32.tar.bz2 )"
LICENSE="Sublime"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="media-libs/libpng
	>=x11-libs/gtk+-2.24.8-r1:2"

src_install() {
	insinto /opt/${PN}
	into /opt/${PN}
	exeinto /opt/${PN}
	doins -r "Icon"
	doins -r "Packages"
	doins "changelog.txt"
	doins "python3.3.zip"
	doins "sublime_plugin.py"
	doins "sublime.py"
	doexe "sublime_text"
	doexe "plugin_host"
	doexe "crash_reporter"
	dosym "/opt/${PN}/sublime_text" /usr/bin/subl
	make_desktop_entry "subl" "Sublime Text Editor" "accessories-text-editor" "TextEditor"
}
