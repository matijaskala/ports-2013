# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="aa ab ae af ak am an ar as ast av ay az ba be bg bh bi bm bn bo br bs ca ce ch ckb co cr cs cu cv cy da de dv dz ee el en_AU en_CA en_GB eo es et eu fa ff fi fj fo fr_CA fr fy ga gd gl gn gu gv ha he hi ho hr ht hu hy hz ia id ie ig ii ik io is it iu ja jv ka kg ki kj kk kl km kn ko kr ks ku kv kw ky la lb lg li ln lo lt lu lv mg mh mi mk ml mn mo mr ms mt my na nb nd ne ng nl nn nr nv ny oc oj om or os pa pi pl ps pt_BR pt qu rm rn ro rue ru rw sa sc sd se sg si sk sl sma sm sn so sq sr ss st su sv sw ta te tg th ti tk tl tn to tr ts tt tw ty ug uk ur uz ve vi vo wa wo xh yi yo za zh_CN zh_HK zh zh_TW zu"

inherit gnome2-utils l10n meson systemd vala

DESCRIPTION="Global Menu plugin for xfce4 and vala-panel"
HOMEPAGE="http://github.com/rilian-la-te/vala-panel-appmenu"
SRC_URI="https://github.com/rilian-la-te/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="mate systemd valapanel +wnck xfce"
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-3.12.0:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	unity-base/bamf
	mate? ( mate-base/mate-panel )
	valapanel? ( x11-misc/vala-panel )
	wnck? ( >=x11-libs/libwnck-3.4.0 )
	xfce? ( >=xfce-base/xfce4-panel-4.11.2 )"
DEPEND="${RDEPEND}
	systemd? ( sys-apps/systemd )"
BDEPEND="$(vala_depend)
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}.patch )

src_prepare() {
	# Remove gio-addons as also done in x11-misc/vala-panel #
	rm -v vapi/gio-addons-2.0.vapi || die
	sed -e '/gio-addons-2.0/d' -i lib/meson.build || die

	l10n_get_locales > po/LINGUAS || die

	vala_src_prepare
	default
}

src_configure() {
	emesonargs=(
		-Dappmenu-gtk-module=enabled
		-Dbudgie=disabled
		-Djayatana=disabled
		-Dregistrar=enabled
		$(meson_feature mate)
		$(meson_feature valapanel)
		$(meson_feature wnck)
		$(meson_feature xfce)
	)
	meson_src_configure
}

src_install () {
	meson_src_install

	use systemd || rm -f "${D}$(systemd_get_systemunitdir)"

	insinto /etc/profile.d
	doins ${FILESDIR}/vala-panel-appmenu.sh
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
