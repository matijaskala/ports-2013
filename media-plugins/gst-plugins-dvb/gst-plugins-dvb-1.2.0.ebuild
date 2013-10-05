# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-dvb/gst-plugins-dvb-1.2.0.ebuild,v 1.1 2013/09/29 18:01:56 eva Exp $

EAPI="5"

inherit gst-plugins10 gst-plugins-bad

DESCRIPION="GStreamer plugin to allow capture from dvb devices"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/os-headers"

src_compile() {
	# Prepare generated headers
	cd "${S}"/gst-libs/gst/mpegts
	emake

	cd "${S}"
	gst-plugins10_src_compile
}
