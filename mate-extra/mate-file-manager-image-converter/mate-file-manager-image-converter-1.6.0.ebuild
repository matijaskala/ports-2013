# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mate

DESCRIPTION="Adds a 'Resize Images' item to the context menu for all images"
HOMEPAGE="http://www.mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=mate-base/mate-file-manager-1.6.0"
RDEPEND="${DEPEND}
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	# Tarball has no proper build system, should be fixed on next release.
	mate_gen_build_system

	gnome2_src_prepare
}
