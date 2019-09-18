# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit vala autotools

DESCRIPTION="LXDE session manager"
HOMEPAGE="https://wiki.lxde.org/en/LXSession"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm ppc x86 ~arm-linux ~x86-linux"
SLOT="0"

# upower USE flag is enabled by default in the desktop profile
IUSE="gtk3 libnotify nls upower"
REQUIRED_USE="?? ( gtk3 libnotify )"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/dbus-glib
	!gtk3? ( dev-libs/libunique:1 )
	lxde-base/lxde-common
	sys-auth/polkit
	gtk3? ( x11-libs/gtk+:3 )
	x11-libs/libX11
	sys-apps/dbus
	libnotify? (
		dev-libs/libappindicator:2
		dev-libs/libindicator:0
		x11-libs/libnotify
	)
"
RDEPEND="${COMMON_DEPEND}
	!lxde-base/lxsession-edit
	sys-apps/lsb-release
	upower? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto
"

PATCHES=(
	# Fedora patches
	"${FILESDIR}"/${PN}-0.5.2-reload.patch
	"${FILESDIR}"/${PN}-0.5.2-notify-daemon-default.patch
	"${FILESDIR}"/${PN}-0.5.2-fix-invalid-memcpy.patch
)

src_prepare() {
	vala_src_prepare

	# Don't start in Xfce to avoid bugs like
	# https://bugzilla.redhat.com/show_bug.cgi?id=616730
	sed -i 's/^\(NotShowIn=GNOME;KDE;.*\)$/\1XFCE;/g' data/lxpolkit.desktop.in.in || die

	default
	eautoreconf
}

src_configure() {
	# dbus is used for restart/shutdown (CK, logind?), and suspend/hibernate (UPower)
	econf \
		$(use_enable nls) \
		$(use_enable gtk3) \
		$(use_enable libnotify advanced-notifications)
	use gtk3 && make clean-generic
}
