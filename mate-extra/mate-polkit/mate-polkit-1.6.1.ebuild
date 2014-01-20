# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit mate

RESTRICT="test"

DESCRIPTION="A dbus session bus service that is used to bring up authentication dialogs"
HOMEPAGE="https://github.com/mate-desktop/mate-polkit"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+introspection"

# We call gtkdocize so we need to depend on gtk-doc.
RDEPEND=">=dev-libs/glib-2.28
	>=x11-libs/gtk+-2.24:2[introspection?]
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

src_configure() {
	DOCS="AUTHORS HACKING NEWS README"

	econf \
		--disable-static \
		$(use_enable introspection)
}

src_compile() {
	emake -C polkitgtkmate libpolkit-gtk-mate-1.la
}
