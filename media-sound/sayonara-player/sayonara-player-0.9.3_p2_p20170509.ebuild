# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg

MY_PV=${PV/_p/-git}; MY_PV=${MY_PV/_p/-}
DESCRIPTION="Small, clear and fast audio player"
HOMEPAGE="https://sayonara-player.com/"
SRC_URI="https://sayonara-player.com/sw/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mtp"
RESTRICT="mirror"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtxml:5
	dev-qt/linguist-tools:5
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/taglib
	mtp? ( media-libs/libmtp:= )
	sys-libs/zlib:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}"/${PN}-0.9.2_p4_p20160920-updates.patch )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package mtp libmtp)
	)

	cmake-utils_src_configure
}
