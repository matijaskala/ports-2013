# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Session init system job for launching applications"
HOMEPAGE="https://launchpad.net/ubuntu-app-launch"
MY_PV="${PV/_p/+16.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+threads"
S=${WORKDIR}
RESTRICT="mirror"

DEPEND="app-admin/cgmanager
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	dev-libs/libzeitgeist
	dev-libs/libupstart
	dev-util/lttng-tools
	dev-util/dbus-test-runner
	mir-base/mir:=
	net-misc/curl
	sys-apps/click
	sys-apps/dbus
	sys-libs/libnih[dbus]"
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
}
