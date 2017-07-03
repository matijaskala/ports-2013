# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools gnome.org readme.gentoo

DESCRIPTION="Integrates xdg-user-dirs into the Gnome desktop and Gtk+ applications"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xdg-user-dirs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+gtk3"

RDEPEND="
	>=x11-misc/xdg-user-dirs-0.14
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}
	!gtk3? ( >=sys-devel/autoconf-2.53 )
	dev-util/intltool
	virtual/pkgconfig
"

DOC_CONTENTS="
	This package tries to automatically use some sensible default
	directories for your documents, music, video and other stuff.
	If you want to change those directories to your needs, see
	the settings in ~/.config/user-dirs.dirs
"

src_prepare() {
	use gtk3 || ( epatch "${FILESDIR}"/xdg-user-dirs-gtk2.patch; eautoconf )
	sed -i \
		-e '/Encoding/d' \
		-e 's:OnlyShowIn=GNOME;LXDE;Unity;:NotShowIn=KDE;:' \
		user-dirs-update-gtk.desktop.in || die
}
