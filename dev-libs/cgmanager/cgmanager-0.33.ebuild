# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit ubuntu

DESCRIPTION="Central cgroup manager daemon"
HOMEPAGE="https://launchpad.net/cgmanager"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="sys-apps/dbus
	sys-apps/help2man
	sys-libs/libnih"
