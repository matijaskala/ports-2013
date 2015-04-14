# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils flag-o-matic ubuntu

DESCRIPTION="Application indicators used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-application"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	dev-libs/libappindicator
	dev-libs/libindicate-qt"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
	append-cflags -Wno-error

	# Make indicator start using XDG autostart #
	sed -e '/NotShowIn=/d' \
		-i data/indicator-application.desktop.in

	# Show systray icons even if they report themselves as 'Passive' #
	epatch -p1 "${FILESDIR}/sni-systray_show-passive.diff"
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules

	# Remove upstart jobs as we use XDG autostart desktop files to spawn indicators #
	rm -rf "${ED}usr/share/upstart"
}
