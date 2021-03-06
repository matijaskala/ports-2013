# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Core data for vcmi"
HOMEPAGE="http://forum.vcmi.eu/index.php"
MY_P="core"
SRC_URI="
	http://download.vcmi.eu/core.zip -> ${PN}-core-${PV}.zip
	http://download.vcmi.eu/WoG/wog.zip -> ${PN}-wog-${PV}.zip
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/${PN%-data}"
	rm -rf Mods/vcmi/Data/s
	doins -r *
}

pkg_postinst() {
	elog "For the game to work properly, please copy your"
	elog 'Heroes Of Might and Magic ("The Wake Of Gods" or'
	elog '"Shadow of Death" or "Complete edition")'
	elog "game directory into /usr/share/${PN}."
	elog "or use 'vcmibuilder' utility on your:"
	elog "   a) One or two CD's or CD images"
	elog "   b) gog.com installer"
	elog "   c) Directory with installed game"
	elog "(although installing it in such way is 'bad practices')."
	elog "For more information, please visit:"
	elog "http://wiki.vcmi.eu/index.php?title=Installation_on_Linux"
}
