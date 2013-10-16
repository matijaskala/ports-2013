# Distributed under the terms of the GNU General Public License v2

EAPI="3"

inherit autotools eutils

DESCRIPTION="BAMF Application Matching Framework"
SRC_URI="http://launchpad.net/${PN}/0.3/${PV}/+download/${P}.tar.gz"
HOMEPAGE="https://launchpad.net/bamf"
KEYWORDS="*"
SLOT="0"
LICENSE="LGPL-3"
IUSE="gtk3 introspection webapps"

DEPEND="
    introspection? ( >=dev-lang/vala-0.11.7 )
    gtk3? (
        >=x11-libs/libwnck-3.2.1
        >=x11-libs/gtk+-3.2.1 )
    gnome-base/libgtop
    dev-util/gtk-doc"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/bamf-gir.patch
	sed -i -e 's/vapigen/vapigen-0.12/' configure.in
	sed -i -e 's/-Werror//' configure.in

	if ! use gtk3;then
		sed -i -e 's/AM_PATH_GTK_3_0/AM_PATH_GTK_2_0/' configure.in
	fi

	eautoreconf
}

src_configure() {
    econf \
        $(use_enable introspection)
        $(use_enable webapps) \
        --with-gtk=$(usex gtk3 "3" "2")
}
