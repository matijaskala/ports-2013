# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit rpm linux-info multilib

MY_P="${PN}-1.0-1.i386"

DESCRIPTION="Printer driver for Lexmark 08z series."
HOMEPAGE="http://www.lexmark.com/"
SRC_URI="http://downloads.lexmark.com/downloads/cpd/${MY_P}.rpm.sh.tar.gz"
RESTRICT="mirror"

LICENSE="Lexmark"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="net-print/cups
	app-text/ghostscript-gpl
	x86? ( =virtual/libstdc++-3.3 )
	amd64? ( app-emulation/emul-linux-x86-compat )"

S="${WORKDIR}"

pkg_setup() {
	CONFIG_CHECK="~USB_PRINTER"
	linux-info_pkg_setup

	use amd64 && multilib_toolchain_setup x86
}

src_unpack() {
	unpack ${A}
	mkdir driver
	./${MY_P}.rpm.sh --noexec --target driver || die
	cd driver
	tar -xvvf instarchive_all --lzma
	rpmunpack ${MY_P}.rpm
}

src_install() {
	cd "driver/${MY_P}/usr/local/lexmark/08zero"
	dodoc docs/{license.txt,readme.txt}
	rm -r docs
	cp -R "${WORKDIR}/driver/${MY_P}/usr" "${D}" || die "could not move /usr"
}

pkg_postinst() {
	/usr/local/lexmark/08z-series-driver.link /usr/local/lexmark
	ln -s /usr/lib/cups/backend/lxk08zusb /usr/libexec/cups/backend/lxkusb

	einfo ""
	einfo "For installing a printer:"
	einfo " * Restart CUPS: /etc/init.d/cupsd restart"
	einfo " * Go to http://127.0.0.1:631/"
	einfo "   -> Printers -> Add Printer"
	einfo ""
}

pkg_prerm() {
	/usr/local/lexmark/08z-series-driver.unlink /usr/local/lexmark
	rm /usr/libexec/cups/backend/lxkusb
}
