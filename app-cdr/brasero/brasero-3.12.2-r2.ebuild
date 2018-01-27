# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools gnome2

DESCRIPTION="CD/DVD burning application for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Brasero"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0/3.1" # subslot is 3.suffix of libbrasero-burn3
IUSE="+introspection +libburn +gtk3 nautilus playlist tracker"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
SRC_URI+=" !gtk3? ( https://github.com/matijaskala/random-patches/raw/dcf4afc7d19ae47b98bb2de4c60c11f617faab40/${PN}-gtk2.patch )"

COMMON_DEPEND="
	>=dev-libs/glib-2.29.14:2
	gtk3? ( >=x11-libs/gtk+-3:3[introspection?] media-libs/libcanberra[gtk3] )
	!gtk3? ( x11-libs/gtk+:2[introspection?] media-libs/libcanberra[gtk] )
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=dev-libs/libxml2-2.6:2
	>=x11-libs/libnotify-0.6.1:=

	x11-libs/libICE
	x11-libs/libSM

	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
	libburn? (
		>=dev-libs/libburn-0.4:=
		>=dev-libs/libisofs-0.6.4:= )
	nautilus? ( >=gnome-base/nautilus-2.91.90 )
	playlist? ( >=dev-libs/totem-pl-parser-2.29.1:= )
	tracker? ( >=app-misc/tracker-1:0= )
"
RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-meta:1.0
	x11-themes/hicolor-icon-theme
	!libburn? (
		app-cdr/cdrdao
		app-cdr/dvd+rw-tools
		virtual/cdrtools )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	dev-util/itstool
	>=dev-util/gtk-doc-am-1.12
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf deps
#	app-text/yelp-tools
#	gnome-base/gnome-common

PDEPEND="gnome-base/gvfs"

src_prepare() {
	if ! use gtk3 ; then
		eapply "${DISTDIR}"/${PN}-gtk2.patch
		eautoreconf
	fi

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-caches \
		$(use_enable !libburn cdrtools) \
		$(use_enable !libburn cdrkit) \
		$(use_enable !libburn cdrdao) \
		$(use_enable !libburn growisofs) \
		$(use_enable introspection) \
		$(use_enable libburn libburnia) \
		$(use_enable nautilus) \
		$(use_enable playlist) \
		$(use_enable tracker search)
}
