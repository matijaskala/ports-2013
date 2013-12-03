# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/siege/siege-3.0.5.ebuild,v 1.1 2013/11/27 04:00:30 patrick Exp $

EAPI=4

#WANT_AUTOMAKE=1.9

inherit eutils bash-completion-r1 libtool autotools

DESCRIPTION="A HTTP regression testing and benchmarking utility"
HOMEPAGE="http://www.joedog.org/JoeDog/Siege"
SRC_URI="http://www.joedog.org/pub/siege/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86"
SLOT="0"
IUSE="ssl"

RDEPEND="ssl? ( >=dev-libs/openssl-0.9.6d )"
DEPEND="${RDEPEND}
	sys-devel/libtool"

src_prepare() {
	# bundled macros break recent libtool
	sed -i -e 's/AC_PROG_SHELL//' configure.ac || die
	rm *.m4 || die "failed to remove bundled macros"
	eautoreconf
}

src_configure() {
	local myconf
	use ssl && myconf="--with-ssl=/usr" || myconf="--without-ssl"
	econf ${myconf}
}

src_install() {
	make DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog INSTALL MACHINES README* KNOWNBUGS \
		doc/siegerc doc/urls.txt

	newbashcomp "${FILESDIR}"/${PN}.bash-completion ${PN}
}

pkg_postinst() {
	echo
	elog "An example ~/.siegerc file has been installed in"
	elog "/usr/share/doc/${PF}/"
}
