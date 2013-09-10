# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ffmpegsource/ffmpegsource-9999.ebuild,v 1.6 2013/05/27 20:23:32 maksbotan Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils subversion

DESCRIPTION="An FFmpeg based source library for easy frame accurate access"
HOMEPAGE="https://code.google.com/p/ffmpegsource/"
ESVN_REPO_URI="http://ffmpegsource.googlecode.com/svn/trunk/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
	>=virtual/ffmpeg-9
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
