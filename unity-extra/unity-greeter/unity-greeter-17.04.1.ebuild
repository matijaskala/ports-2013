# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic gnome2-utils vala

DESCRIPTION="The greeter (login screen) application for Unity. It is implemented as a LightDM greeter."
HOMEPAGE="https://launchpad.net/unity-greeter"
SRC_URI="http://launchpad.net/${PN}/17.04/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="accessibility battery networkmanager nls"
RESTRICT="mirror"

DEPEND="dev-libs/libindicator
	gnome-base/gnome-desktop:3=
	media-libs/freetype:2
	media-libs/libcanberra
	unity-base/unity-settings-daemon
	unity-indicators/ido
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-misc/lightdm[vala]
	$(vala_depend)"

RDEPEND="accessibility? ( app-accessibility/onboard
			app-accessibility/orca )
	battery? ( unity-indicators/indicator-power )
	networkmanager? ( >=gnome-extra/nm-applet-0.9.8.0 )
	>=app-eselect/eselect-lightdm-0.1
	>=gnome-base/gsettings-desktop-schemas-3.8
	media-fonts/ubuntu-font-family
	unity-base/unity-language-pack
	unity-indicators/indicator-session
	unity-indicators/indicator-datetime
	unity-indicators/indicator-sound
	unity-indicators/indicator-application
	x11-themes/ubuntu-wallpapers"

src_prepare() {
	# patch 'at-spi-bus-launcher' path
	sed -i -e "s:/usr/lib/at-spi2-core/at-spi-bus-launcher:/usr/libexec/at-spi-bus-launcher:" \
                  "${S}"/src/unity-greeter.vala || die

	# replace 'Ubuntu*' session with 'Unity' session to get right badge
	sed -i -e "s:case \"ubuntu:case \"unity:" "${S}"/src/session-list.vala || die

	vala_src_prepare
	eapply_user
	append-cflags -Wno-error
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${ED}" install

	# Remove all installed language files as they can be incomplete #
	# due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"


	prune_libtool_files --modules
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update

	elog "Setting ${PN} as default greeter of LightDM."
	"${ROOT}"/usr/bin/eselect lightdm set unity-greeter

	elog "Setting 'unity' as default user session."
	if line=$(grep -s -m 1 -e "user-session" "/etc/lightdm/lightdm.conf"); then
		sed -i -e "s/user-session=.*/user-session=unity/" "/etc/lightdm/lightdm.conf"
	else
		echo "user-session=unity" >> "${EROOT}/etc/lightdm/lightdm.conf"
	fi
}

pkg_postrm() {
	if [ -e /usr/libexec/lightdm/lightdm-set-defaults ]; then
		elog "Removing ${PN} as default greeter of LightDM"
		/usr/libexec/lightdm/lightdm-set-defaults --remove --greeter=${PN}
		/usr/libexec/lightdm/lightdm-set-defaults --remove --session=unity
	fi
	gnome2_schemas_update
}
