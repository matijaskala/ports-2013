# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $id$

EAPI=5

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${PN}-${PV/_/-}.tar.xz"
	;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="EFL Video Player"
HOMEPAGE="https://enlightenment.org"
RESTRICT="mirror"
IUSE=""
LICENSE="BSD-2"
SLOT="0"

EFL_VERSION=1.13.0
RDEPEND=">=dev-libs/efl-${EFL_VERSION}
	>=media-libs/elementary-${EFL_VERSION}"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README TODO )
