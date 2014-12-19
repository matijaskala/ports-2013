# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

SRC_SUFFIX="orig.tar.bz2"

inherit base gnome2 cmake-utils ubuntu

DESCRIPTION="Dconf Qt bindings for the Unity desktop"
HOMEPAGE="https://launchpad.net/dconf-qt"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.32.3
	dev-qt/qtcore:4
	dev-qt/qtdeclarative:4
	gnome-base/dconf"
DEPEND="${RDEPEND}"

S="${WORKDIR}/lib${PN}-0.0.0"
