# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

UPN="ubuntu-app-launch"
inherit cmake-utils ubuntu

DESCRIPTION="Session init system job for launching applications, libraries only"
HOMEPAGE="https://launchpad.net/ubuntu-app-launch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+threads"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/cgmanager
	dev-libs/json-glib
	dev-libs/libzeitgeist
	dev-libs/libupstart
	>=dev-util/lttng-tools-2.5.0
	dev-util/dbus-test-runner
	sys-apps/click
	sys-libs/libnih[dbus]"

src_install() {
	cmake-utils_src_install

	# Only install libraries and includes #
	rm -rf "${ED}usr/share" "${ED}usr/libexec" "${ED}usr/bin"
}
