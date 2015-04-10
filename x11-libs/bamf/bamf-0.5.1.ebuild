# Distributed under the terms of the GNU General Public License v2

EAPI=5
VALA_USE_DEPEND=vapigen
PYTHON_COMPAT=( python2_7 )

UVER_PREFIX="+14.04.20140409"

inherit autotools eutils ubuntu vala python-single-r1

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="dev-libs/gobject-introspection
	dev-libs/libxslt[python,${PYTHON_USEDEP}]
	dev-libs/libxml2[${PYTHON_USEDEP}]
	dev-util/gdbus-codegen
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libwnck:1
	>=x11-libs/libwnck-3.4.7:3
	x11-libs/libXfixes
	$(vala_depend)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN=$VAPIGEN

	sed -e "s:-Werror::g" \
		-i "configure.ac" || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-introspection=yes \
		--disable-static || die
}
