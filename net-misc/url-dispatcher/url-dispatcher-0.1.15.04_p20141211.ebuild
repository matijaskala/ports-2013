# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils ubuntu

DESCRIPTION="Service to allow sending of URLs and get handlers started, used by the Unity desktop"
HOMEPAGE="https://launchpad.net/url-dispatcher"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:="
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-libs/ubuntu-app-launch
	sys-apps/dbus
	test? ( dev-util/dbus-test-runner )"

src_install() {
	cmake-utils_src_install

	# Remove upstart jobs as we use xsession based scripts in /etc/X11/xinit/xinitrc.d/ #
	rm -rf "${ED}usr/share/upstart"

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/99url-dispatcher"
}
