# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk+/gtk+-3.6.3-r3.ebuild,v 1.2 2013/10/17 20:44:36 maekke Exp $

EAPI="5"

inherit eutils flag-o-matic gnome.org gnome2-utils multilib virtualx

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="3"
# NOTE: This gtk+ has multi-gdk-backend support, see:
#  * http://blogs.gnome.org/kris/2010/12/29/gdk-3-0-on-mac-os-x/
#  * http://mail.gnome.org/archives/gtk-devel-list/2010-November/msg00099.html
# I tried this and got it all compiling, but the end result is unusable as it
# horribly mixes up the backends -- grobian
IUSE="aqua colord cups debug egl examples +introspection packagekit test vim-syntax wayland X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	xinerama? ( X )"

KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# FIXME: introspection data is built against system installation of gtk+:3
# NOTE: cairo[svg] dep is due to bug 291283 (not patched to avoid eautoreconf)
# Use gtk+:2 for gtk-update-icon-cache
COMMON_DEPEND="X? (
		>=app-accessibility/at-spi2-atk-2.5.3
		x11-libs/libXrender
		x11-libs/libX11
		>=x11-libs/libXi-1.3
		x11-libs/libXext
		>=x11-libs/libXrandr-1.3
		x11-libs/libXcursor
		x11-libs/libXfixes
		x11-libs/libXcomposite
		x11-libs/libXdamage
		xinerama? ( x11-libs/libXinerama )
	)
	wayland? (
		>=dev-libs/wayland-1.0
		media-libs/mesa[egl?,wayland]
		>=x11-libs/libxkbcommon-0.2
		egl? ( x11-libs/cairo[opengl] )
	)
	>=dev-libs/glib-2.33.1
	>=x11-libs/pango-1.30[introspection?]
	>=dev-libs/atk-2.5.3[introspection?]
	>=x11-libs/cairo-1.10.0:=[aqua?,glib,svg,X?]
	>=x11-libs/gdk-pixbuf-2.26:2[introspection?,X?]
	>=x11-libs/gtk+-2.24:2
	media-libs/fontconfig
	x11-misc/shared-mime-info
	colord? ( >=x11-misc/colord-0.1.9 )
	cups? ( >=net-print/cups-1.2:= )
	introspection? ( >=dev-libs/gobject-introspection-1.32 )"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	virtual/pkgconfig
	X? (
		x11-proto/xextproto
		x11-proto/xproto
		x11-proto/inputproto
		x11-proto/damageproto
		xinerama? ( x11-proto/xineramaproto )
	)
	>=dev-util/gtk-doc-am-1.11
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"
# gtk+-3.2.2 breaks Alt key handling in <=x11-libs/vte-0.30.1:2.90
# gtk+-3.3.18 breaks scrolling in <=x11-libs/vte-0.31.0:2.90
# >=xorg-server-1.11.4 needed for
#  http://mail.gnome.org/archives/desktop-devel-list/2012-March/msg00024.html
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gail-1000
	!<x11-libs/vte-0.31.0:2.90
	packagekit? ( app-admin/packagekit-base )
	X? ( !<x11-base/xorg-server-1.11.4 )"
PDEPEND="vim-syntax? ( app-vim/gtk-syntax )"

strip_builddir() {
	local rule=$1
	shift
	local directory=$1
	shift
	sed -e "s/^\(${rule} =.*\)${directory}\(.*\)$/\1\2/" -i $@ \
		|| die "Could not strip director ${directory} from build."
}

src_prepare() {
	# -O3 and company cause random crashes in applications. Bug #133469
	replace-flags -O3 -O2
	strip-flags

	# https://bugzilla.gnome.org/show_bug.cgi?id=654108
	epatch "${FILESDIR}/${PN}-3.3.18-fallback-theme.patch"

	# Crashes when opening various dialogs, bug #450370; fixed in 3.6.4
	epatch "${FILESDIR}/${P}-stylecontext-font-crash.patch"

	# Fix QA violation, bug #422541, upstream bug #704767
	epatch "${FILESDIR}/${P}-darwin-gtksettings.patch"

	# Symbolic icon loading with librsvg-2.36.4-r1 and 2.39.0, bug #487110; fixed in 3.8.3
	epatch "${FILESDIR}/${P}-librsvg-2.39.patch"

	# Non-working test in gentoo's env
	sed 's:\(g_test_add_func ("/ui-tests/keys-events.*\):/*\1*/:g' \
		-i gtk/tests/testing.c || die "sed 1 failed"
	sed '\%/recent-manager/add%,/recent_manager_purge/ d' \
		-i gtk/tests/recentmanager.c || die "sed 2 failed"

	# FIXME: multiple reftests fail when run from portage (but succeed when
	# run from a manual compile in a temp directory)
	sed -e 's:\(SUBDIRS.*\)reftests:\1:' \
		-i tests/Makefile.* || die "sed 3 failed"

	# Test results depend on the list of mounted filesystems!
	rm -v tests/a11y/pickers.{ui,txt} || die "rm failed"

	if ! use test; then
		# don't waste time building tests
		strip_builddir SRC_SUBDIRS tests Makefile.am
		[[ ${PV} != 9999 ]] && strip_builddir SRC_SUBDIRS tests Makefile.in
	fi

	if ! use examples; then
		# don't waste time building demos
		strip_builddir SRC_SUBDIRS demos Makefile.am
		[[ ${PV} != 9999 ]] && strip_builddir SRC_SUBDIRS demos Makefile.in
	fi

	epatch_user

	[[ ${PV} = 9999 ]] && gnome2_src_prepare
}

src_configure() {
	# Passing --disable-debug is not recommended for production use
	# need libdir here to avoid a double slash in a path that libtool doesn't
	# grok so well during install (// between $EPREFIX and usr ...)
	econf \
		$(use_enable aqua quartz-backend) \
		$(usex wayland $(use_enable egl wayland-cairo-gl) "") \
		$(use_enable colord) \
		$(use_enable cups cups auto) \
		$(usex debug --enable-debug=yes "") \
		$(use_enable introspection) \
		$(use_enable packagekit) \
		$(use_enable wayland wayland-backend) \
		$(use_enable X x11-backend) \
		$(use_enable X xcomposite) \
		$(use_enable X xdamage) \
		$(use_enable X xfixes) \
		$(use_enable X xkb) \
		$(use_enable X xrandr) \
		$(use_enable xinerama) \
		--disable-papi \
		--enable-man \
		--enable-gtk2-dependency \
		--with-xml-catalog="${EPREFIX}"/etc/xml/catalog \
		--libdir="${EPREFIX}/usr/$(get_libdir)"
}

src_test() {
	# Tests require a new gnome-themes-standard, but adding it to DEPEND
	# would result in circular dependencies.
	# https://bugzilla.gnome.org/show_bug.cgi?id=669562
	if ! has_version '>=x11-themes/gnome-themes-standard-3.6[gtk]'; then
		ewarn "Tests will be skipped because >=gnome-themes-standard-3.6[gtk]"
		ewarn "is not installed. Please re-run tests after installing the"
		ewarn "required version of gnome-themes-standard."
		return 0
	fi
	unset DBUS_SESSION_BUS_ADDRESS
	# Exporting HOME fixes tests using XDG directories spec since all defaults
	# are based on $HOME. It is also backward compatible with functions not
	# yet ported to this spec.
	XDG_DATA_HOME="${T}" HOME="${T}" Xemake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/gtk-3.0
	doins "${FILESDIR}"/settings.ini

	dodoc AUTHORS ChangeLog* HACKING NEWS* README*

	# Remove unneeded *.la files
	prune_libtool_files --all

	# add -framework Carbon to the .pc files
	use aqua && for i in gtk+-3.0.pc gtk+-quartz-3.0.pc gtk+-unix-print-3.0.pc; do
		sed -i -e "s:Libs\: :Libs\: -framework Carbon :" "${ED}"usr/$(get_libdir)/pkgconfig/$i || die "sed failed"
	done
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update

	local GTK3_MODDIR="${EROOT}usr/$(get_libdir)/gtk-3.0/3.0.0"
	gtk-query-immodules-3.0  > "${GTK3_MODDIR}/immodules.cache" \
		|| ewarn "Failed to run gtk-query-immodules-3.0"

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi
}

pkg_postrm() {
	gnome2_schemas_update
}
