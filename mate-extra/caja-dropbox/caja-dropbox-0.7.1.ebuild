# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_{6,7} )
GNOME2_LA_PUNT="yes"
inherit autotools eutils python-single-r1 linux-info mate user

DESCRIPTION="Store, Sync and Share Files Online"
HOMEPAGE="http://www.dropbox.com/"
SRC_URI="http://pub.mate-desktop.org/releases/1.4/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-linux"
IUSE="debug"

RDEPEND="mate-base/mate-file-manager
	dev-libs/glib:2
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	net-misc/dropbox
	x11-libs/gtk+:2
	x11-libs/libXinerama"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-python/docutils"

DOCS="AUTHORS ChangeLog NEWS README"
G2CONF="${G2CONF} $(use_enable debug) --disable-static"

CONFIG_CHECK="~INOTIFY_USER"

pkg_setup () {
	python-single-r1_pkg_setup
	check_extra_config
	enewgroup dropbox
}

src_prepare() {
	gnome2_src_prepare

	# use sysem dropbox
	sed -e "s|~/[.]dropbox-dist|/opt/dropbox|" \
		-e 's|\(DROPBOXD_PATH = \).*|\1"/opt/dropbox/dropboxd"|' \
			-i dropbox.in || die
	# us system rst2man
	epatch "${FILESDIR}"/${PN}-0.7.0-system-rst2man.patch
	AT_NOELIBTOOLIZE=yes eautoreconf
}

src_install () {
	python_fix_shebang dropbox.in

	gnome2_src_install

	local extensiondir="$(pkg-config --variable=extensiondir libcaja-extension)"
	[ -z ${extensiondir} ] && die "pkg-config unable to get caja extensions dir"

	# Strip $EPREFIX from $extensiondir as fowners/fperms act on $ED not $D
	extensiondir="${extensiondir#${EPREFIX}}"

	use prefix || fowners root:dropbox "${extensiondir}"/libcaja-dropbox.so
	fperms o-rwx "${extensiondir}"/libcaja-dropbox.so
}

pkg_postinst () {
	gnome2_pkg_postinst

	elog
	elog "Add any users who wish to have access to the dropbox caja"
	elog "plugin to the group 'dropbox'. You need to setup a drobox account"
	elog "before using this plugin. Visit ${HOMEPAGE} for more information."
	elog
}
