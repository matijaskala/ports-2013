# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-opus/gst-plugins-opus-1.0.10.ebuild,v 1.10 2013/10/22 07:21:24 ago Exp $

EAPI="5"

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for Opus audio codec support"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-0.9.4:="
RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-base:${SLOT}[ogg]"
DEPEND="${COMMON_DEPEND}"
