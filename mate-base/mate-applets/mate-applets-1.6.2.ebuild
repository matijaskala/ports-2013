# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_{6,7} )

inherit mate python-single-r1

DESCRIPTION="Applets for the MATE Desktop and Panel"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ipv6 networkmanager policykit"

RDEPEND=">=x11-libs/gtk+-2.20:2
	>=dev-libs/glib-2.22:2
	>=mate-base/mate-panel-1.5.2
	>=x11-libs/libxklavier-4.0
	>=x11-libs/libmatewnck-1.3.0
	>=mate-base/mate-desktop-1.2.0
	>=x11-libs/libnotify-0.7.0
	>=sys-apps/dbus-1.1.2
	>=dev-libs/dbus-glib-0.74
	>=sys-power/upower-0.9.4
	>=dev-libs/libxml2-2.5.0:2
	>=x11-themes/mate-icon-theme-1.2.0
	>=dev-libs/libmateweather-1.6.1
	x11-libs/libX11
	>=mate-base/mate-settings-daemon-1.2.0
	gnome-base/libgtop:2
	sys-power/cpufrequtils
	mate-extra/mate-character-map
	dev-python/pygobject:3
	networkmanager? ( >=net-misc/networkmanager-0.7.0 )
	policykit? ( >=sys-auth/polkit-0.92 )"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.1.4
	>=app-text/mate-doc-utils-1.2.1
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	dev-libs/libxslt
	~app-text/docbook-xml-dtd-4.3
	>=mate-base/mate-common-1.2.2"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	gnome2_src_configure \
		--libexecdir=/usr/libexec/mate-applets \
		--without-hal \
		$(use_enable ipv6) \
		$(use_enable networkmanager) \
		$(use_enable policykit polkit)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check
}

src_install() {
	python_fix_shebang invest-applet timer-applet/src
	gnome2_src_install

	local APPLETS="accessx-status battstat charpick cpufreq drivemount geyes
			invest-applet mateweather mini-commander mixer modemlights
			multiload null_applet stickynotes timer-applet trashapplet"

	for applet in ${APPLETS}; do
		docinto ${applet}

		for d in AUTHORS ChangeLog NEWS README README.themes TODO; do
			[ -s ${applet}/${d} ] && dodoc ${applet}/${d}
		done
	done
}
