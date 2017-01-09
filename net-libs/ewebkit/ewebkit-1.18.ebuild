# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

inherit cmake-utils flag-o-matic python-any-r1 ruby-single

DESCRIPTION="EFL port of open source web browser engine"
HOMEPAGE="http://trac.webkit.org/wiki/EFLWebKit"
SRC_URI="https://download.enlightenment.org/rel/libs/webkit-efl/${P}.tar.xz"

LICENSE="LGPL-2+ BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="battery coverage geolocation gles2 glib gstreamer nsplugin svg webgl xslt"
RESTRICT="mirror test"

RDEPEND="
	dev-db/sqlite:3=
	glib? ( net-libs/libsoup )
	!glib? ( net-misc/curl )
	>=dev-libs/icu-3.8.1-r1:=
	>=dev-libs/libxml2-2.8:2
	xslt? ( dev-libs/xslt )
	dev-libs/elf[fontconfig,glib?]
	>=media-libs/freetype-2.4.2:2
	>=media-libs/harfbuzz-0.9.18:=[icu(+)]
	>=media-libs/libpng-1.4:0=
	virtual/jpeg:0=
	>=x11-libs/cairo-1.10.2:=
	|| ( dev-libs/efl[X] dev-libs/elf[xcb] )
	geolocation? ( >=app-misc/geoclue-2.1.5:2.0 )
	gles2? ( media-libs/mesa[gles2] )
	gstreamer? (
		>=media-libs/gstreamer-1.2:1.0
		>=media-libs/gst-plugins-base-1.2:1.0
		>=media-libs/gst-plugins-bad-1.5.0:1.0[opengl] )
	webgl? (
		x11-libs/cairo[opengl]
		x11-libs/libXcomposite
		x11-libs/libXdamage )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=dev-util/gperf-3.0.1
	>=sys-devel/bison-2.4.3
	sys-devel/gettext
	virtual/pkgconfig

	geolocation? ( dev-util/gdbus-codegen )
"

S=${WORKDIR}/${PN}

src_configure() {
	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# It does not compile on alpha without this in LDFLAGS
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648761
	use alpha && append-ldflags "-Wl,--no-relax"

	local ruby_interpreter=""

	if has_version "virtual/rubygems[ruby_targets_ruby23]"; then
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby23)"
	elif has_version "virtual/rubygems[ruby_targets_ruby22]"; then
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby22)"
	elif has_version "virtual/rubygems[ruby_targets_ruby21]"; then
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby21)"
	else
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby20)"
	fi

	local mycmakeargs=(
		-DPORT=Efl
		$(cmake-utils_use_enable glib GLIB_SUPPORT)
		$(cmake-utils_use_enable nsplugin NETSCAPE_PLUGIN_API)
		$(cmake-utils_use_enable gles2)
		$(cmake-utils_use_enable gstreamer VIDEO)
		$(cmake-utils_use_enable gstreamer WEB_AUDIO)
		$(cmake-utils_use_enable geolocation)
		$(cmake-utils_use_enable battery BATTERY_STATUS)
		$(cmake-utils_use_enable svg)
		$(cmake-utils_use_enable svg SVG_FONTS)
		$(cmake-utils_use_enable webgl)
		$(cmake-utils_use_enable xslt)
		${ruby_interpreter}
	)

	cmake-utils_src_configure
}
