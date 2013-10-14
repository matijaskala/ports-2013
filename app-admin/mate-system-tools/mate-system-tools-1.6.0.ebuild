# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

EAPI="5"
GCONF_DEBUG="no"
MATE_LA_PUNT="yes"

inherit autotools eutils mate

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
	caja? ( mate-base/mate-file-manager )
	sys-libs/cracklib
	nfs? ( net-fs/nfs-utils )
	samba? ( >=net-fs/samba-3 )
	policykit? (
		>=sys-auth/polkit-0.92
		mate-extra/mate-polkit )"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/scrollkeeper
	app-text/mate-doc-utils
	virtual/pkgconfig
	>=dev-util/intltool-0.35.0"

src_prepare() {
	# add -lm to linker, fixed upstream
	sed -i 's:DBUS_LIBS):DBUS_LIBS) -lm:' \
		src/time/Makefile.am || die

	mate_src_prepare
}

pkg_setup() {
	if ! use nfs && ! use samba; then
		G2CONF="${G2CONF} --disable-shares"
	fi

	DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static \
		$(use_enable policykit polkit-gtk) \
		$(use_enable caja)"
}
