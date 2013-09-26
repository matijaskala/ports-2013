# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit mate

DESCRIPTION="Multimedia related programs for the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="aac flac mp3 pulseaudio speex twolame vorbis"

# FIXME: automagic dev-util/glade:3 support
COMMON_DEPEND="dev-libs/libxml2:2
	>=dev-libs/glib-2.18.2:2
	>=x11-libs/gtk+-2.18.0:2
	>=mate-base/mate-panel-1.5.0
	>=mate-base/mate-desktop-1.5.0
	>=media-libs/gstreamer-0.10.23:0.10
	>=media-libs/gst-plugins-base-0.10.23:0.10
	>=media-libs/gst-plugins-good-0.10:0.10
	>=media-libs/libcanberra-0.13[gtk]
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-gconf-0.10.1:0.10
	>=dev-libs/libunique-1:1
	pulseaudio? ( >=media-sound/pulseaudio-0.9.16[glib] )"
# Specific gst plugins are used by the default audio encoding profiles
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:0.10[flac?,vorbis?]
	aac? (
		media-plugins/gst-plugins-faac:0.10
		media-plugins/gst-plugins-ffmpeg:0.10 )
	mp3? (
		media-libs/gst-plugins-ugly:0.10
		media-plugins/gst-plugins-taglib:0.10
		media-plugins/gst-plugins-lame:0.10 )
	speex? (
		media-plugins/gst-plugins-ogg:0.10
		media-plugins/gst-plugins-speex:0.10 )
	twolame? (
		media-plugins/gst-plugins-taglib:0.10
		media-plugins/gst-plugins-twolame:0.10 )"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	virtual/pkgconfig
	>=app-text/scrollkeeper-0.3.11
	app-text/mate-doc-utils
	>=dev-util/intltool-0.35.0
	!!<mate-base/mate-applets-1.6.0"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable pulseaudio)
		$(use_enable !pulseaudio gstmix)
		$(use_enable !pulseaudio gst-mixer-applet)"
	DOCS="AUTHORS ChangeLog* NEWS README"
}

pkg_postinst() {
	mate_pkg_postinst
	ewarn
	ewarn "If you cannot play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
	if use pulseaudio; then
		ewarn "You have enabled pulseaudio support, gstmixer will not be built"
		ewarn "If you do not use pulseaudio, you do not want this"
	fi
}
