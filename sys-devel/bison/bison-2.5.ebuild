# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils

DESCRIPTION="A yacc-compatible parser generator"
HOMEPAGE="http://www.gnu.org/software/bison/bison.html"
SRC_URI="mirror://gnu/bison/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="nls static"

RDEPENED=">=sys-devel/m4-1.4.16"
DEPEND="nls? ( sys-devel/gettext )"

src_configure() {
	use static && append-ldflags -static
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die

	# This one is installed by dev-util/yacc
	mv "${D}"/usr/bin/yacc{,.bison} || die
	mv "${D}"/usr/share/man/man1/yacc{,.bison}.1 || die

	# We do not need this.
	rm -r "${D}"/usr/lib* || die

	dodoc AUTHORS NEWS ChangeLog README OChangeLog THANKS TODO
}

pkg_postinst() {
	if [[ ! -e ${ROOT}/usr/bin/yacc ]] ; then
		ln -s yacc.bison "${ROOT}"/usr/bin/yacc
	fi
}
