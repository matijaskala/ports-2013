# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="LightDM Webkit Greeter"
HOMEPAGE="http://launchpad.net/lightdm-webkit-greeter"
SRC_URI="https://github.com/antergos/web-greeter/archive/stable.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-libs/dbus-glib
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	x11-misc/lightdm"
DEPEND="${RDEPEND}"

S=${WORKDIR}/web-greeter-stable
