# Distributed under the terms of the GNU General Public License v2

EAPI=5
VALA_USE_DEPEND=vapigen
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils vala python-single-r1

UVER_PREFIX="+14.04.20140409"
DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"
SRC_URI="https://launchpad.net/ubuntu/utopic/+source/bamf/${PV}${UVER_PREFIX}-0ubuntu1/+files/bamf_${PV}${UVER_PREFIX}.orig.tar.gz"
KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="LGPL-3"
IUSE="+introspection"

DEPEND="dev-libs/gobject-introspection
	dev-libs/libxslt[python,${PYTHON_USEDEP}]
	dev-libs/libxml2[${PYTHON_USEDEP}]
	$(vala_depend)"

S="${WORKDIR}/${P}${UVER_PREFIX}"
RDEPEND="
	introspection? ( >=dev-lang/vala-0.11.7 )
	>=x11-libs/libwnck-3.4.7:3
	>=x11-libs/gtk+-3.4.7:3
	gnome-base/libgtop"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's/-Werror//' configure.ac
	eautoreconf

	vala_src_prepare
}

src_configure() {
	VALA_API_GEN="${VAPIGEN}" \
	econf \
		$(use_enable introspection)
}
