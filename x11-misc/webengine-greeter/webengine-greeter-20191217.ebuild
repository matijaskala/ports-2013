# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="LightDM WebEngine Greeter"
HOMEPAGE="https://github.com/webengine-greeter"
GIT_COMMIT="f685eba2676060598dd5f0e5feae643e2935f426"
SRC_URI="https://github.com/matijaskala/webengine-greeter/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="
	dev-qt/qtwebengine[widgets]
	x11-misc/lightdm[qt5]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${GIT_COMMIT}
