# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"

inherit mate pam virtualx

DESCRIPTION="Password and keyring managing daemon for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug pam test"
# USE=valgrind is probably not a good idea for the tree

RDEPEND=">=dev-libs/glib-2.25:2
	x11-libs/gtk+:2
	>=sys-apps/dbus-1.0
	pam? ( virtual/pam )
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1"
#	valgrind? ( dev-util/valgrind )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig"
PDEPEND=">=mate-base/libmatekeyring-1.6.0"

# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.9

# tests fail in several ways, they should be fixed in the next cycle (bug #340283),
# revisit then.
RESTRICT="test"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs="${EPREFIX}"/usr/share/ca-certificates/
		--with-gtk=2.0
		--enable-ssh-agent
		--enable-gpg-agent"
#		$(use_enable valgrind)
}

src_prepare() {
	mate_src_prepare

	# Remove silly CFLAGS
	sed 's:CFLAGS="$CFLAGS -Werror:CFLAGS="$CFLAGS:' \
		-i configure.ac configure || die "sed CFLAGS failed"

	# Remove DISABLE_DEPRECATED flags
	sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i configure.ac configure || die "sed DISABLE_DEPRECATED failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "emake check failed!"
}
