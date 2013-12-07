# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit mate

DESCRIPTION="MATE session manager"
HOMEPAGE="http://mate-desktop.org/"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="-gtk3 ipv6 elibc_FreeBSD systemd"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).
RDEPEND=">=dev-libs/glib-2.16:2
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	>=dev-libs/dbus-glib-0.76
	>=sys-power/upower-0.9.0
	elibc_FreeBSD? ( dev-libs/libexecinfo )

	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXtst
	x11-apps/xdpyinfo

	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=sys-devel/gettext-0.10.40
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	>=mate-base/mate-common-1.2.2
	!<gnome-base/gdm-2.20.4
	systemd? ( sys-apps/systemd )"

# gnome-common needed for eautoreconf
# gnome-base/gdm does not provide gnome.desktop anymore

pkg_setup() {
	use gtk3 && G2CONF="${G2CONF} --with-gtk=3.0"
	use !gtk3 && G2CONF="${G2CONF} --with-gtk=2.0"

	# TODO: convert libnotify to a configure option
	G2CONF="${G2CONF}
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--with-default-wm=mate-wm
		$(use_enable ipv6)
		$(use_with systemd)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	# Add "session saving" button back:
	# see https://bugzilla.gnome.org/show_bug.cgi?id=575544
	epatch "${FILESDIR}/${PN}-1.5.2-save-session-ui.patch"

	# Fix race condition in idle monitor, GNOME bug applies to MATE too,
	# see https://bugzilla.gnome.org/show_bug.cgi?id=627903
	epatch "${FILESDIR}/${PN}-1.2.0-idle-transition.patch"

	eautoreconf
	mate_src_prepare
}

src_install() {
	mate_src_install

	dodir /etc/X11/Sessions
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/MATE"

	dodir /usr/share/mate/applications/
	insinto /usr/share/mate/applications/
	doins "${FILESDIR}/defaults.list"

	dodir /etc/X11/xinit/xinitrc.d/
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/15-xdg-data-mate"

	# This should be done in MATE too, see Gentoo bug #270852
	doexe "${FILESDIR}/10-user-dirs-update-mate"
}
