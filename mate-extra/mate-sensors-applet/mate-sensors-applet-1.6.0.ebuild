# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/sensors-applet/sensors-applet-2.2.7-r1.ebuild,v 1.10 2012/05/05 06:25:22 jdhore Exp $

EAPI="5"
GCONF_DEBUG="no"
MATE_LA_PUNT="yes"

inherit eutils mate

DESCRIPTION="Mate panel applet to display readings from hardware sensors"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+dbus hddtemp libnotify lm_sensors video_cards_fglrx video_cards_nvidia"

RDEPEND="
	>=dev-libs/glib-2.14:2
	>=x11-libs/gtk+-2.14:2
	mate-base/mate-panel
	>=x11-libs/cairo-1.0.4
	hddtemp? (
		dbus? (
			>=dev-libs/dbus-glib-0.80
			>=dev-libs/libatasmart-0.16 )
		!dbus? ( >=app-admin/hddtemp-0.3_beta13 ) )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	lm_sensors? ( sys-apps/lm_sensors )
	video_cards_fglrx? ( x11-drivers/ati-drivers )
	video_cards_nvidia? ( || (
		>=x11-drivers/nvidia-drivers-100.14.09
		media-video/nvidia-settings
	) )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=app-text/scrollkeeper-0.3.14
	>=app-text/mate-doc-utils-1.2.1
	dev-util/intltool"
# Requires libxslt only for use by gnome-doc-utils

PDEPEND="hddtemp? ( dbus? ( sys-fs/udisks:0 ) )"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"

	local myconf
	if use hddtemp && use dbus; then
		myconf="${myconf} $(use_enable dbus udisks)"
	else
		myconf="${myconf} --disable-udisks"
	fi

	mate_src_configure \
		--disable-scrollkeeper \
		--disable-static \
		$(use_enable libnotify) \
		$(use_with lm_sensors libsensors) \
		$(use_with video_cards_fglrx aticonfig) \
		$(use_with video_cards_nvidia nvidia) \
		${myconf}
}
