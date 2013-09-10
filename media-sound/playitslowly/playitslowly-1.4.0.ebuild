# Copyright 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2

EAPI=4-python
PYTHON_MULTIPLE_ABIS=1
PYTHON_RESTRICTED_ABIS="2.5 3.* *-jython *-pypy-*"

inherit distutils

DESCRIPTION="A tool to help you when transcribing music. It allows you to play a piece of music at a different speed or pitch"
HOMEPAGE="http://29a.ch/playitslowly/"
SRC_URI="http://29a.ch/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa mp3"

DEPEND=""
RDEPEND="${DEPEND}
	$(python_abi_depend ">=dev-python/pygtk-2.10")
	>=media-libs/gstreamer-0.10
	>=dev-python/gst-python-0.10
	media-plugins/gst-plugins-soundtouch
	media-libs/gst-plugins-good
	mp3? ( media-plugins/gst-plugins-mad )
	alsa? ( media-plugins/gst-plugins-alsa )"

src_install() {
	distutils_src_install
	dodoc README CHANGELOG
}

