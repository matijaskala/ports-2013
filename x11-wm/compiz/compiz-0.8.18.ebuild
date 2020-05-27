# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils

DESCRIPTION="OpenGL window and compositing manager"
HOMEPAGE="https://gitlab.com/compiz"
SRC_URI="https://github.com/compiz-reloaded/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="+cairo dbus fuse +gtk mate +svg"
RESTRICT="mirror"

DEPEND="
	>=dev-libs/glib-2
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/libpng:0=
	media-libs/mesa
	x11-base/xorg-server
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/libXrender-0.9.3
	>=x11-libs/startup-notification-0.7
	virtual/glu
	cairo? ( x11-libs/cairo[X] )
	dbus? ( sys-apps/dbus )
	fuse? ( sys-fs/fuse )
	svg? ( gnome-base/librsvg:2 )
"

RDEPEND="${DEPEND}"

BDEPEND="
	virtual/pkgconfig
	x11-base/xorg-proto
"

PDEPEND="gtk? ( x11-wm/gtk-window-decorator )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=( )
	myconf+=(
		--enable-menu-entries
		--disable-static
		$(use_enable cairo annotate)
		--disable-compizconfig
		$(use_enable dbus)
		--disable-dbus-glib
		$(use_enable fuse)
		--disable-gsettings
		$(use_enable svg librsvg)
		--disable-marco
		$(use_enable mate)
		--disable-gtk
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	dodir /etc/skel/.config/compiz/compizconfig

	cat <<- EOF > "${D}/etc/skel/.config/compiz/compizconfig/Default.ini"
	[core]
	as_active_plugins = core;workarounds;dbus;resize;crashhandler;mousepoll;decoration;svg;wall;place;png;text;imgjpeg;move;regex;animation;ezoom;switcher;
	s0_hsize = 2
	s0_vsize = 2

	EOF
}

compiz_icon_cache_update() {
	# Needed because compiz needs its own icon cache.
	# Based on https://gitweb.gentoo.org/repo/gentoo.git/tree/eclass/gnome2-utils.eclass#n241
	local dir="${EROOT}/usr/share/compiz/icons/hicolor"
	local updater="${EROOT}/usr/bin/gtk-update-icon-cache"
	if [[ -n "$(ls "$dir")" ]]; then
		"${updater}" -q -f -t "${dir}"
		rv=$?

		if [[ ! $rv -eq 0 ]] ; then
			debug-print "Updating cache failed on ${dir}"

			# Add to the list of failures
			fails+=( "${dir}" )

			retval=2
		fi
	elif [[ $(ls "${dir}") = "icon-theme.cache" ]]; then
		# Clear stale cache files after theme uninstallation
		rm "${dir}/icon-theme.cache"
	fi

	if [[ -z $(ls "${dir}") ]]; then
		# Clear empty theme directories after theme uninstallation
		rmdir "${dir}"
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
	compiz_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	compiz_icon_cache_update
}
