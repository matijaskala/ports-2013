# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 eutils gnome2-utils

DESCRIPTION="Compiz Fusion Tray Icon and Manager"
HOMEPAGE="https://gitlab.com/compiz"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+gtk gtk3 qt5"
RESTRICT="mirror"

REQUIRED_USE="gtk3? ( gtk ) || ( gtk qt5 )"

RDEPEND="
	>=dev-python/compizconfig-python-0.8.12[${PYTHON_USEDEP}]
	<dev-python/compizconfig-python-0.9
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-apps/xvinfo
	>=x11-wm/compiz-0.8
	<x11-wm/compiz-0.9
	gtk? (
		!gtk3? ( dev-libs/libappindicator:2 )
		gtk3? ( dev-libs/libappindicator:3 )
	)
	qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-qt4-interface-subprocess-call.patch )

python_configure_all() {
	mydistutilsargs=(
		build
		--with-gtk=$(usex gtk3 3.0 2.0)
	)
}

python_install_all() {
	distutils-r1_python_install_all
	use gtk || rm -r "${D}$(python_get_sitedir)/FusionIcon/interface_gtk" || die
	use qt5 || rm -r "${D}$(python_get_sitedir)/FusionIcon/interface_qt" || die
}

pkg_postinst() {
	use gtk && gnome2_icon_cache_update
}

pkg_postrm() {
	use gtk && gnome2_icon_cache_update
}
