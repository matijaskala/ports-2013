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
IUSE="caja"

# Doesn't build against gtk+-3 so remove useflag and dep for now.
RDEPEND="x11-libs/gtk+:2
	>=dev-libs/glib-2.25.5:2
	caja? ( >=mate-base/mate-file-manager-1.2.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	>=app-text/mate-doc-utils-1.2.1
	>=mate-base/mate-common-1.2.2"

src_prepare() {
	#Fix crash because of missing keys in schema
	epatch "${FILESDIR}/${P}-schema-fix.patch"

	# Fix help file so test pass
	for po in help/*/*.po;do \
		sed -i 's/^"roller-/"engrampa-/g' ${po}; \
		sed -i 's/linkend=\\"file-/linkend=\\"/g' ${po};done || die

	# Tarball has no proper build system, should be fixed on next release.
	mate_gen_build_system

	gnome2_src_prepare

	# Drop DEPRECATED flags as configure option doesn't do it, bug #385453
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		copy-n-paste/Makefile.am copy-n-paste/Makefile.in || die
}

src_configure() {
	DOCS="AUTHORS HACKING MAINTAINERS NEWS README TODO"

	gnome2_src_configure \
		--disable-run-in-place \
		--disable-packagekit \
		--disable-deprecations \
		--with-gtk=2.0 \
		$(use_enable caja caja-actions)
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
