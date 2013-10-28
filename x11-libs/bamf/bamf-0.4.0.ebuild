# Distributed under the terms of the GNU General Public License v2

EAPI=4
VALA_USE_DEPEND=vapigen

inherit autotools eutils vala

DESCRIPTION="BAMF Application Matching Framework"
SRC_URI="http://launchpad.net/${PN}/0.4/${PV}/+download/${P}.tar.gz"
HOMEPAGE="https://launchpad.net/bamf"
KEYWORDS="*"
SLOT="0"
LICENSE="LGPL-3"
IUSE="introspection webapps"

RDEPEND="
    introspection? ( >=dev-lang/vala-0.11.7 )
    >=x11-libs/libwnck-3.2.1
    >=x11-libs/gtk+-3.2.1
    gnome-base/libgtop"
DEPEND="${RDEPEND}
    $(vala_depend)
    virtual/pkgconfig"

src_prepare() {
  	sed -i -e 's/-Werror//' configure.in
	  eautoreconf

  	vala_src_prepare
}

src_configure() {
	  VALA_API_GEN="${VAPIGEN}" \
    econf \
        $(use_enable introspection)
        $(use_enable webapps) \
        --with-gtk=3
}
