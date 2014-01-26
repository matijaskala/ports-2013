# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit multilib

DESCRIPTION="Meta ebuild for MATE, The traditional desktop environment"
HOMEPAGE="http://mate-desktop.org"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE="bluetooth gtk3 +extras"

RDEPEND=">=mate-base/libmatekbd-1.7.0[gtk3?]
	>=dev-libs/libmateweather-1.7.0[gtk3?]
	>=x11-themes/mate-icon-theme-1.7.0
	>=mate-extra/mate-dialogs-1.7.0
	>=mate-base/mate-desktop-1.7.0[gtk3?]
	>=mate-base/caja-1.7.0[gtk3?]
	>=x11-themes/mate-backgrounds-1.7.0
	>=mate-base/mate-menus-1.7.0
	>=x11-wm/mate-window-manager-1.6.0
	>=mate-extra/mate-polkit-1.7.0
	>=mate-base/mate-settings-daemon-1.7.0[gtk3?]
	>=mate-base/mate-control-center-1.6.0
	>=mate-base/mate-panel-1.7.0[gtk3?]
	>=mate-base/mate-session-manager-1.7.0[gtk3?]
	>=x11-themes/mate-themes-1.7.0
	>=mate-extra/mate-utils-1.6.0
	>=mate-extra/mate-media-1.7.0
	>=x11-misc/mate-menu-editor-1.6.0
	>=x11-terms/mate-terminal-1.7.0
	>=mate-base/mate-applets-1.7.0
	virtual/notification-daemon
	extras? (
		>=mate-extra/mate-power-manager-1.7.0
		>=app-editors/pluma-1.7.0
		>=app-arch/engrampa-1.7.0
		>=media-gfx/mate-image-viewer-1.6.0
		>=app-text/atril-1.7.0
		>=mate-extra/mate-system-monitor-1.7.0
		>=mate-extra/mate-calc-1.7.0
		>=mate-extra/mate-screensaver-1.7.0
	)
	bluetooth? ( >=net-wireless/mate-bluetooth-1.6.0 )"

pkg_postinst() {
	elog "If you found a bug and have a solution, contact joost_op in #sabayon-dev at freenode.net."
	elog "Mate 1.6 moved from mateconf to gsettings. This means that the desktop settings and panel applets will return to their default."
	elog "You will have to reconfigure your desktop appearance."
	elog ""
	elog "There is a script (mate-conf-import) that converts from mateconf to gsettings"
	elog "Run it with 'python2 /usr/$(get_libdir)/mate-desktop/mate-conf-import'"
	elog "For support with this script see the following url"
	elog "http://forums.mate-desktop.org/viewtopic.php?f=16&t=1650"
}
