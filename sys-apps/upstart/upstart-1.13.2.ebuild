# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Event-based replacement for the /sbin/init daemon."
HOMEPAGE="http://upstart.ubuntu.com/"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+threads"
RESTRICT="mirror"

RDEPEND="!dev-libs/libupstart"
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

	## Remove unecessary files colliding with sysvinit, we only need 'upstart --user' to start Unity desktop services ##
	rm -rfv ${ED}usr/share/man/man5
	rm -rv ${ED}usr/share/man/man8/{halt,init,poweroff,reboot,restart,runlevel,shutdown,telinit}.8
	rm -rv ${ED}usr/share/man/man7/runlevel.7
	rm -rv ${ED}usr/sbin/{halt,init,poweroff,reboot,runlevel,shutdown,telinit}

	insinto /usr/share/upstart/sessions/
	doins "${FILESDIR}/dbus.conf"

	exeinto /usr/bin
	newexe init/init upstart

	insinto /usr/share/man/man8
	newins init/man/init.8 upstart.8

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${FILESDIR}/99upstart"

	prune_libtool_files --modules
}
