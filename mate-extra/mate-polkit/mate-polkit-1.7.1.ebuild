# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="no"

inherit autotools mate

DESCRIPTION="A dbus session bus service that is used to bring up authentication dialogs"
HOMEPAGE="https://github.com/mate-desktop/mate-polkit"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+introspection gtk3"

RDEPEND=">=dev-libs/glib-2.28
	gtk3? ( >=x11-libs/gtk+-2.24:2[introspection?] )
	!gtk3? ( x11-libs/gtk+:3 )
	>=sys-auth/polkit-0.102[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.2 )"

DEPEND="${RDEPEND}
	dev-util/intltool
	!<gnome-extra/polkit-gnome-0.102
	mate-base/mate-common
	sys-devel/gettext
	virtual/pkgconfig"

# Entropy PMS specific. This way we can install the pkg
# into the build chroots.
ENTROPY_RDEPEND="!lxde-base/lxpolkit"

src_prepare() {
	eautoreconf
	mate_src_prepare
}

src_configure() {
	DOCS="AUTHORS HACKING NEWS README"

	local myconf
	use gtk3 && myconf="${myconf} --with-gtk=3.0"
	use !gtk3 && myconf="${myconf} --with-gtk=2.0"

	mate_src_configure \ 
		--disable-static \
		$(use_enable introspection) \
		${myconf}
}


