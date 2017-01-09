# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Default LightDM Webkit Theme"
HOMEPAGE=""
EGIT_REPO_URI="git://github.com/matijaskala/lightdm-theme-default.git"
SRC_URI=""

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="media-plugins/gst-plugins-lame:1.0
	|| (
		( net-libs/webkit-gtk:2[gstreamer] >=x11-misc/lightdm-webkit-greeter-2.0.0[-gtk3] )
		( net-libs/webkit-gtk:3[gstreamer] >=x11-misc/lightdm-webkit-greeter-2.0.0[gtk3] )
	)"

src_install() {
	newenvd - 45lightdm << EOF
CONFIG_PROTECT="/usr/share/lightdm-webkit/themes/default"
EOF

	insinto /usr/share/lightdm-webkit/themes/default
	doins -r *
}
