# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils mate

DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="caja nfs policykit samba"

RDEPEND="
	>=app-admin/system-tools-backends-2.10.1
	>=dev-libs/liboobs-2.31.91
	>=x11-libs/gtk+-2.19.7:2
	>=dev-libs/glib-2.25.3:2
	dev-libs/dbus-glib
	caja? ( mate-base/caja )
	sys-libs/cracklib
	nfs? ( net-fs/nfs-utils )
	samba? ( >=net-fs/samba-3 )
	policykit? (
		>=sys-auth/polkit-0.92
		mate-extra/mate-polkit )"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/scrollkeeper
	virtual/pkgconfig
	>=dev-util/intltool-0.35.0"

src_configure() {
	DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

	local myconf
	if ! use nfs && ! use samba; then
		myconf="--disable-shares"
	fi

	gnome2_src_configure \
		${myconf} \
		--disable-static \
		$(use_enable policykit polkit-gtk-mate) \
		$(use_enable caja)
}
