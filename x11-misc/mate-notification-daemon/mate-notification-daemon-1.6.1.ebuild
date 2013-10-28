# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
MATE_LA_PUNT="yes"

inherit mate

DESCRIPTION="MATE Notification daemon"
HOMEPAGE="http://mate-dekstop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="-gtk3"

RDEPEND=">=dev-libs/glib-2.4:2
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	>=dev-libs/dbus-glib-0.78
	>=sys-apps/dbus-1
	>=media-libs/libcanberra-0.4[gtk]
	>=x11-libs/libnotify-0.7.0
	x11-libs/libmatewnck
	x11-libs/libX11
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon
	!x11-misc/notification-daemon"

DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS ChangeLog NEWS )

src_install() {
	mate_src_install

	keepdir /etc/mateconf/mateconf.xml.mandatory
	keepdir /etc/mateconf/mateconf.xml.defaults
	# Make sure this directory exists
	keepdir /etc/mateconf/mateconf.xml.system

	cat <<-EOF > "${T}/org.freedesktop.Notifications.service"
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/mate-notification-daemon
	EOF

	insinto /usr/share/dbus-1/services
	doins "${T}/org.freedesktop.Notifications.service"
}
