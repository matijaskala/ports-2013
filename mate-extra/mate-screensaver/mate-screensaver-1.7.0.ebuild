# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit mate multilib

DESCRIPTION="Replaces xscreensaver, integrating with the MATE desktop."
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
KERNEL_IUSE="kernel_linux"
IUSE="gtk3 libnotify opengl pam systemd consolekit $KERNEL_IUSE"

RDEPEND="
	>=mate-base/mate-desktop-1.7.1
	>=mate-base/mate-menus-1.5.0
	>=dev-libs/glib-2.15:2
	!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	>=mate-base/libmatekbd-1.7.1
	>=dev-libs/dbus-glib-0.71
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	opengl? ( virtual/opengl )
	pam? ( virtual/pam )
	!pam? ( kernel_linux? ( sys-apps/shadow ) )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	!!<gnome-extra/gnome-screensaver-3.0.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto
	>=mate-base/mate-common-1.7.0
	systemd? ( sys-apps/systemd )
	consolekit? ( sys-auth/consolekit )"

src_prepare() {
	# We use gnome-keyring now, update pam file
	sed -e 's:mate_keyring:gnome_keyring:g' -i data/mate-screensaver || die "sed failed"
	gnome2_src_prepare

}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_with libnotify)
		$(use_with opengl libgl)
		$(use_enable pam)
		$(use_with systemd)
		$(use_with consolekit console-kit)
		--enable-locking
		--with-xf86gamma-ext
		--with-kbd-layout-indicator
		--with-xscreensaverdir=/usr/share/xscreensaver/config
		--with-xscreensaverhackdir=/usr/$(get_libdir)/misc/xscreensaver"
		use gtk3 && G2CONF="${G2CONF} --with-gtk=3.0"
		use !gtk3 && G2CONF="${G2CONF} --with-gtk=2.0"

		gnome2_src_configure
}

src_install() {
	gnome2_src_install

	# Install the conversion script in the documentation
	dodoc "${S}/data/migrate-xscreensaver-config.sh"
	dodoc "${S}/data/xscreensaver-config.xsl"

	# Non PAM users will need this suid to read the password hashes.
	# OpenPAM users will probably need this too when
	# http://bugzilla.gnome.org/show_bug.cgi?id=370847
	# is fixed.
	if ! use pam ; then
		fperms u+s /usr/libexec/mate-screensaver-dialog
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	if has_version "<x11-base/xorg-server-1.5.3-r4" ; then
		ewarn "You have a too old xorg-server installation. This will cause"
		ewarn "gnome-screensaver to eat up your CPU. Please consider upgrading."
		echo
	fi

	if has_version "<x11-misc/xscreensaver-4.22-r2" ; then
		ewarn "You have xscreensaver installed, you probably want to disable it."
		ewarn "To prevent a duplicate screensaver entry in the menu, you need to"
		ewarn "build xscreensaver with -gnome in the USE flags."
		ewarn "echo \"x11-misc/xscreensaver -gnome\" >> /etc/portage/package.use"
		echo
	fi

	elog "Information for converting screensavers is located in "
	elog "/usr/share/doc/${PF}/xss-conversion.txt.${PORTAGE_COMPRESS}"
}
