# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit gnome2

DESCRIPTION="A collaboration and sharing tool that is designed to keep things simple and to stay out of your way."
HOMEPAGE="http://sparkleshare.org/"
SRC_URI="https://github.com/downloads/hbons/SparkleShare/${PN}-linux-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="debug doc gtk libnotify +nautilus"

RDEPEND=">=dev-lang/mono-2.2
	gtk? (
		>=dev-dotnet/gtk-sharp-2.12.2
		>=dev-dotnet/glib-sharp-2.12.2
		libnotify? ( dev-dotnet/notify-sharp )
	)
	dev-dotnet/webkit-sharp
	nautilus? ( dev-python/nautilus-python )
	>=dev-vcs/git-1.7.1
	virtual/libintl"
#	appindicator? ( >=dev-dotnet/appindicator-sharp-0.0.7 )
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	doc? ( >=app-text/gnome-doc-utils-0.17.3 )"

src_configure() {
	local myconf
	if use debug ; then
		myconf="${myconf} --enable-debug"
	else
		myconf="${myconf} --enable-release"
	fi
	# --enable-gtkui b0rked
	if ! use gtk ; then
		myconf="${myconf} --disable-gtkui"
	fi
	econf \
		$(use_enable nautilus nautilus-extension) \
		${myconf}
}

src_compile() {
	# Parallel build seems to be broken
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS NEWS
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
