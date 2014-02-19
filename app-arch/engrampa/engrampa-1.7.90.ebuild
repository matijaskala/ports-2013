# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit mate

DESCRIPTION="Engrampa archive manager for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3 caja"

# Doesn't build against gtk+-3 so remove useflag and dep for now.
RDEPEND=">=dev-libs/glib-2.25.5:2
	!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	caja? ( >=mate-base/caja-1.7.0 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	>=mate-base/mate-common-1.7.0
	!!app-arch/mate-file-archiver"

src_prepare() {
	gnome2_src_prepare

	# Drop DEPRECATED flags as configure option doesn't do it, bug #385453
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		copy-n-paste/Makefile.am copy-n-paste/Makefile.in || die
}

src_configure() {
	DOCS="AUTHORS HACKING MAINTAINERS NEWS README TODO"

	G2CONF="$G2CONF} --disable-run-in-place
		--disable-packagekit
		--disable-deprecations
		$(use_enable caja caja-actions)"
	use gtk3 && G2CONF="${G2CONF} --with-gtk=3.0"
	use !gtk3 && G2CONF="${G2CONF} --with-gtk=2.0"

	gnome2_src_configure
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "${PN} is a frontend for several archiving utilities. If you want a"
	elog "particular achive format support install the relevant package."
	elog
	elog "for example:"
	elog "  7-zip   - app-arch/p7zip"
	elog "  ace     - app-arch/unace"
	elog "  arj     - app-arch/arj"
	elog "  cpio    - app-arch/cpio"
	elog "  deb     - app-arch/dpkg"
	elog "  iso     - app-cdr/cdrtools"
	elog "  jar,zip - app-arch/zip and app-arch/unzip"
	elog "  lha     - app-arch/lha"
	elog "  lzma    - app-arch/xz-utils"
	elog "  lzop    - app-arch/lzop"
	elog "  rar     - app-arch/unrar"
	elog "  rpm     - app-arch/rpm"
	elog "  unstuff - app-arch/stuffit"
	elog "  zoo     - app-arch/zoo"
}
