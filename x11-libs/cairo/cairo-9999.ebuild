# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/cairo/cairo-9999.ebuild,v 1.39 2014/04/28 17:50:00 mgorny Exp $

EAPI=5

inherit eutils flag-o-matic autotools multilib-minimal

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/cairo"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://cairographics.org/releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="http://cairographics.org/"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
IUSE="X aqua debug directfb drm gallium gles2 +glib legacy-drivers opengl openvg qt4 static-libs +svg valgrind xcb xlib-xcb"
# gtk-doc regeneration doesn't seem to work with out-of-source builds
#[[ ${PV} == *9999* ]] && IUSE="${IUSE} doc" # API docs are provided in tarball, no need to regenerate

# Test causes a circular depend on gtk+... since gtk+ needs cairo but test needs gtk+ so we need to block it
RESTRICT="test"

RDEPEND="dev-libs/lzo[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.30.0[${MULTILIB_USEDEP}]
	directfb? ( dev-libs/DirectFB )
	gles2? ( media-libs/mesa[gles2,${MULTILIB_USEDEP}] )
	glib? ( >=dev-libs/glib-2.28.6:2[${MULTILIB_USEDEP}] )
	opengl? ( || ( media-libs/mesa[egl,${MULTILIB_USEDEP}] media-libs/opengl-apple ) )
	openvg? ( media-libs/mesa[openvg,${MULTILIB_USEDEP}] )
	qt4? ( >=dev-qt/qtgui-4.8:4 )
	X? (
		>=x11-libs/libXrender-0.6[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		drm? (
			>=virtual/udev-136[${MULTILIB_USEDEP}]
			gallium? ( media-libs/mesa[gallium,${MULTILIB_USEDEP}] )
		)
	)
	xcb? (
		x11-libs/libxcb[${MULTILIB_USEDEP}]
	)
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20131008-r1
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/libtool-2
	X? (
		x11-proto/renderproto[${MULTILIB_USEDEP}]
		drm? (
			x11-proto/xproto[${MULTILIB_USEDEP}]
			>=x11-proto/xextproto-7.1[${MULTILIB_USEDEP}]
		)
	)"
#[[ ${PV} == *9999* ]] && DEPEND="${DEPEND}
#	doc? (
#		>=dev-util/gtk-doc-1.6
#		~app-text/docbook-xml-dtd-4.2
#	)"

# drm module requires X
# for gallium we need to enable drm
REQUIRED_USE="
	drm? ( X )
	gallium? ( drm )
	gles2? ( !opengl )
	openvg? ( || ( gles2 opengl ) )
	xlib-xcb? ( xcb )
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/cairo/cairo-features.h
	/usr/include/cairo/cairo-directfb.h
)

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.8.8-interix.patch
	use legacy-drivers && epatch "${FILESDIR}"/${PN}-1.10.0-buggy_gradients.patch
	epatch "${FILESDIR}"/${PN}-respect-fontconfig.patch
	epatch_user

	# Slightly messed build system YAY
	if [[ ${PV} == *9999* ]]; then
		touch boilerplate/Makefile.am.features
		touch src/Makefile.am.features
		touch ChangeLog
	fi

	# We need to run elibtoolize to ensure correct so versioning on FreeBSD
	# upgraded to an eautoreconf for the above interix patch.
	eautoreconf
}

multilib_src_configure() {
	local myopts

	[[ ${CHOST} == *-interix* ]] && append-flags -D_REENTRANT

	use elibc_FreeBSD && myopts+=" --disable-symbol-lookup"

	# TODO: remove this (and add USE-dep) when DirectFB is converted,
	# bug #484248 -- but beware of the circular dep.
	if ! multilib_is_native_abi; then
		myopts+=" --disable-directfb"
	fi

	# TODO: remove this (and add USE-dep) when qtgui is converted, bug #498010
	if ! multilib_is_native_abi; then
		myopts+=" --disable-qt"
	fi

	# [[ ${PV} == *9999* ]] && myopts+=" $(use_enable doc gtk-doc)"

	ECONF_SOURCE="${S}" \
	econf \
		--disable-dependency-tracking \
		$(use_with X x) \
		$(use_enable X tee) \
		$(use_enable X xlib) \
		$(use_enable X xlib-xrender) \
		$(use_enable aqua quartz) \
		$(use_enable aqua quartz-image) \
		$(use_enable debug test-surfaces) \
		$(use_enable drm) \
		$(use_enable directfb) \
		$(use_enable gallium) \
		$(use_enable gles2 glesv2) \
		$(use_enable glib gobject) \
		$(use_enable openvg vg) \
		$(use_enable opengl gl) \
		$(use_enable qt4 qt) \
		$(use_enable static-libs static) \
		$(use_enable svg) \
		$(use_enable valgrind) \
		$(use_enable xcb) \
		$(use_enable xcb xcb-shm) \
		$(use_enable xlib-xcb) \
		--enable-ft \
		--enable-pdf \
		--enable-png \
		--enable-ps \
		${myopts}
}

multilib_src_install() {
	# parallel make install fails
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}

pkg_postinst() {
	if use !xlib-xcb; then
		if has_version net-misc/nxserver-freenx \
				|| has_version net-misc/x2goserver; then
			ewarn "cairo-1.12 is known to cause GTK+ errors with NX servers."
			ewarn "Enable USE=\"xlib-xcb\" if you notice incorrect behavior in GTK+"
			ewarn "applications that are running inside NX sessions. For details, see"
			ewarn "https://bugs.gentoo.org/441878 or https://bugs.freedesktop.org/59173"
		fi
	fi
}
