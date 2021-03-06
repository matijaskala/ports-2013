# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Event-based replacement for the /sbin/init daemon."
HOMEPAGE="http://upstart.ubuntu.com/"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/upstart_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+threads"
S=${WORKDIR}/upstart-${PV}
RESTRICT="mirror"

RDEPEND="!sys-apps/upstart"
DEPEND="sys-devel/gettext
	sys-libs/libnih[dbus]
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable threads threading)
}

src_install() {
	emake DESTDIR="${ED}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HACKING NEWS README TODO

	# Only install libraries and includes #
	rm -rf "${ED}usr/share" "${ED}usr/sbin" "${ED}usr/bin" "${ED}etc"

	prune_libtool_files --modules
}
