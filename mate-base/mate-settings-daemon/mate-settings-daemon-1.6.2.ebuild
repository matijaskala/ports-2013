# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"

inherit eutils mate

DESCRIPTION="MATE Settings Daemon"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug libnotify policykit pulseaudio smartcard"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.18:2
	x11-libs/gtk+:2
	>=mate-base/libmatekbd-1.6.1
	>=mate-base/mate-desktop-1.6.0
	>=gnome-base/dconf-0.13.4

	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.0
	media-libs/fontconfig

	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	policykit? (
		>=sys-auth/polkit-0.91
		>=dev-libs/dbus-glib-0.71
		>=sys-apps/dbus-1.1.2 )
	pulseaudio? (
		>=media-sound/pulseaudio-0.9.15
		media-libs/libcanberra[gtk] )
	!pulseaudio? (
		>=media-libs/gstreamer-0.10.1.2:0.10
		>=media-libs/gst-plugins-base-0.10.1.2:0.10 )
	smartcard? ( >=dev-libs/nss-3.11.2 )"

# 50-accessibility.xml moved to gnome-control-center in gnome-3
RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	x11-proto/inputproto
	x11-proto/xproto"

src_prepare() {
	# More network filesystems not to monitor, upstream bug #606421
	epatch "${FILESDIR}/${PN}-1.4.0-netfs-monitor.patch"

	# mouse: Use event driven mode for syndaemon
	epatch "${FILESDIR}/${PN}-1.2.0-syndaemon-mode.patch"

	mate_src_prepare
}

src_configure() {
	# README is empty
	DOCS="AUTHORS NEWS ChangeLog"

	mate_src_configure \
		$(use_with libnotify) \
		$(use_enable policykit polkit) \
		$(use_enable pulseaudio pulse) \
		$(use_enable !pulseaudio gstreamer) \
		$(use_enable smartcard smartcard-support)

	if use pulseaudio; then
		elog "Building volume media keys using Pulseaudio"
	else
		elog "Building volume media keys using GStreamer"
	fi
}
