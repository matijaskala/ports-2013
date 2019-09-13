# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="netbsd-libcurses portable edition"
HOMEPAGE="https://github.com/sabotage-linux/netbsd-curses"
SRC_URI="http://ftp.barfooze.de/pub/sabotage/tarballs/netbsd-curses-0.3.1.tar.xz"

LICENSE="BSD"
SLOT="0"
IUSE="+doc static-libs"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="!sys-libs/ncurses"

multilib_src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" \
		$(usex static-libs install install-dynlibs) \
		$(usex doc install-manpages "")

	dodoc README.md

	# fix file collisions with attr
	if use doc; then
		rm "${ED%/}/usr/share/man/man3/attr_get.3" || die
		rm "${ED%/}/usr/share/man/man3/attr_set.3" || die
	fi
}
