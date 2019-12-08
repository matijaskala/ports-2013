# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="aa ab ae af ak am an ar as ast av ay az ba be bg bh bi bm bn bn_IN bo br bs ca ce ch ckb co cr cs cu cv cy da de dv dz ee el en_AU en_CA en_GB eo es es_VE et eu fa ff fi fj fo fr fr_CA frp fy ga gd gl gn gu gv ha he hi ho hr ht hu hy hz ia id ie ig ii ik io is it iu ja jv ka kg ki kj kk kl km kn ko kr ks ku kv kw ky la lb lg li ln lo lt lu lv mg mh mi mk ml mn mo mr ms mt my na nb nd ne ng nl nn nr nv ny oc oj om or os pa pi pl ps pt pt_BR qu rm rn ro ru rue rw sa sc sd se sg si sk sl sm sma sn so sq sr sr@latin ss st su sv sw ta te tg th ti tk tl tn to tr ts tt tt_RU tw ty ug uk ur ur_PK uz ve vi vo wa wo xh yi yo za zh zh_CN zh_HK zh_TW zu"

inherit gnome2-utils l10n meson vala

DESCRIPTION="Lightweight desktop panel"
HOMEPAGE="https://github.com/rilian-la-te/vala-panel"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/${PN}/${PV}+dfsg1-1/${PN}_${PV}+dfsg1.orig.tar.xz"

LICENSE="LGPL-3"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="+wnck"
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-3.24.10:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=dev-libs/libpeas-1.2.0
	wnck? ( >=x11-libs/libwnck-3.4.0:3 )"
DEPEND="${RDEPEND}"
BDEPEND="$(vala_depend)
	sys-devel/gettext
	virtual/pkgconfig"

GNOME2_ECLASS_GLIB_SCHEMAS="org.valapanel.gschema.xml"

src_prepare() {
	l10n_get_locales > po/LINGUAS || die

	vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_feature wnck)
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
