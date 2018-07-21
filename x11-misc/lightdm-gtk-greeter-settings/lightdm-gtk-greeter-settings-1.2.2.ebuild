# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit distutils-r1 gnome2-utils eapi7-ver

DESCRIPTION="Settings editor for LightDM GTK+ Greeter"
HOMEPAGE="https://launchpad.net/lightdm-gtk-greeter-settings"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	>=dev-python/python-distutils-extra-2.18[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-devel/gettext
"
RDEPEND="
	dev-libs/glib:2
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	sys-auth/polkit
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	x11-misc/lightdm-gtk-greeter
"

RESTRICT="mirror"

python_install() {
	distutils-r1_python_install --xfce-integration
	rm -r "${ED}"/usr/share/doc/${PN} || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
