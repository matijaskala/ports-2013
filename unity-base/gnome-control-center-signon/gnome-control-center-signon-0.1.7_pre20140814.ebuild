# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2 vala

UVER_PREFIX="~+14.10.20140814"

DESCRIPTION="Online account plugin for unity-control-center used by the Unity desktop"
HOMEPAGE="https://launchpad.net/online-accounts-gnome-control-center"
MY_PV="${PV/_pre/~+14.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

RDEPEND="net-im/pidgin[-eds,dbus,gadu,groupwise,idn,meanwhile,networkmanager,sasl,silc,zephyr]
	net-im/telepathy-logger
	net-irc/telepathy-idle
	net-voip/telepathy-gabble
	net-voip/telepathy-haze
	net-voip/telepathy-rakia
	net-voip/telepathy-salut
	unity-base/signon-ui"
DEPEND="net-libs/libaccounts-glib:=
	net-libs/libsignon-glib:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-libs/gtk+:3
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto
	$(vala_depend)"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	vala_src_prepare
	eautoreconf
}

src_configure() {
	econf --disable-coverage
}

pkg_postinst() {
	elog "To reset all Online Accounts do the following as your desktop user:"
	elog "rm -rfv ~/.cache/telepathy ~/.local/share/telepathy ~/.config/libaccounts-glib"
}
