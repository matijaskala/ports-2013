# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils versionator

MY_PN="${PN/plugins/plug-ins}"
MY_PV=$(get_version_component_range '1-2')

DESCRIPTION="Official plugins for cairo-dock"
HOMEPAGE="https://www.glx-dock.org"
SRC_URI="https://launchpad.net/${MY_PN}/${MY_PV}/${PV}/+download/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa clock dbusmenu disks doncky exif gmenu gnome impulse indicator kde mail mono nwmon scooby sensors terminal tomboy upower vala webkit xfce xgamma xklavier xrandr zeitgeist"
RESTRICT="mirror"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/librsvg:2
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtkglext
	~x11-misc/cairo-dock-${PV}

	alsa? ( media-libs/alsa-lib )
	clock? ( dev-libs/libical )
	dbusmenu? ( dev-libs/libdbusmenu[gtk3] )
	exif? ( media-libs/libexif )
	gmenu? ( gnome-base/gnome-menus )
	indicator? ( dev-libs/libindicator:3= )
	mail? ( net-libs/libetpan )
	mono? ( dev-dotnet/glib-sharp )
	sensors? ( sys-apps/lm_sensors )
	terminal? ( x11-libs/vte:= )
	upower? ( sys-power/upower )
	vala? ( dev-lang/vala )
	webkit? ( net-libs/webkit-gtk:3 )
	xgamma? ( x11-libs/libXxf86vm )
	xklavier? ( x11-libs/libxklavier )
	zeitgeist? ( gnome-extra/zeitgeist )
"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	CFLAGS+=" -D_POSIX_C_SOURCE=200809L"
	local mycmakeargs=(
		"-Denable-alsa-mixer=$(usex alsa)"
		"-Denable-dbusmenu-support=$(usex dbusmenu)"
		"-Denable-disks=$(usex disks)"
		"-Denable-doncky=$(usex doncky)"
		"-Denable-exif-support=$(usex exif)"
		"-Denable-gmenu=$(usex gmenu)"
		"-Denable-gnome-integration=$(usex gnome)"
		"-Denable-ical-support=$(usex clock)"
		"-Denable-impulse=$(usex impulse)"
		"-Denable-kde-integration=$(usex kde)"
		"-Denable-mail=$(usex mail)"
		"-Denable-mono-interface=$(usex mono)"
		"-Denable-network-monitor=$(usex nwmon)"
		"-Denable-recent-events=$(usex zeitgeist)"
		"-Denable-sensors-support=$(usex sensors)"
		"-Denable-scooby-do=$(usex scooby)"
		"-Denable-terminal=$(usex terminal)"
		"-Denable-upower-support=$(usex upower)"
		"-Denable-vala-interface=$(usex vala)"
		"-Denable-weblets=$(usex webkit)"
		"-Denable-xfce-integration=$(usex xfce)"
		"-Denable-xgamma=$(usex xgamma)"
		"-Denable-xrandr-support=$(usex xrandr)"
	)
	cmake-utils_src_configure
}
