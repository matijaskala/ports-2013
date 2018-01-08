# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A GTK+ based user accounts manager"
HOMEPAGE="https://github.com/matijaskala/user-accounts"
SRC_URI="https://github.com/matijaskala/user-accounts/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+faces"
RESTRICT="mirror"

COMMON_DEPEND="
	>=dev-libs/glib-2.39.91
	>=dev-libs/libpwquality-1.2.2
	>=gnome-base/gsettings-desktop-schemas-3.15.4
	>=sys-apps/accountsservice-0.6.39
	>=sys-auth/polkit-0.103
	>=x11-libs/gdk-pixbuf-2.23.0
	virtual/krb5
	x11-libs/gtk+:2"
RDEPEND="${COMMON_DEPEND}
	faces? ( !gnome-base/gnome-control-center )"
DEPEND="${COMMON_DEPEND}
	dev-util/gdbus-codegen
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	eapply "${FILESDIR}"/gdk_cursor_unref.patch
	eapply_user
	eautoreconf -i
}

src_configure() {
	econf $(use_with faces)
}
