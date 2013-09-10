# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools depend.php multilib

MY_PN="ZoneMinder"

DESCRIPTION="ZoneMinder allows you to capture, analyse, record and monitor video cameras attached to your system."
HOMEPAGE="http://www.zoneminder.com/"
SRC_URI="http://www.zoneminder.com/downloads/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug ffmpeg X10 daemon cgi"
SLOT="0"

if use cgi ; then inherit webapp ; fi

MAKEOPTS="${MAKEOPTS} -j1"

ZM_DEPEND="
	X10? ( dev-perl/X10 )
	app-admin/webapp-config
	dev-lang/perl
	dev-lang/php
	dev-libs/libpcre
	perl-core/Archive-Tar
	dev-perl/Archive-Zip
	dev-perl/DBD-mysql
	dev-perl/DBI
	dev-perl/DateManip
	dev-perl/Device-SerialPort
	dev-perl/MIME-Lite
	dev-perl/MIME-tools
	dev-perl/PHP-Serialization
	dev-perl/libwww-perl
	ffmpeg? ( media-video/ffmpeg )
	media-libs/jpeg
	media-libs/netpbm
	net-libs/gnutls
	perl-core/Module-Load
	virtual/httpd-cgi
	virtual/perl-Archive-Tar
	virtual/perl-Getopt-Long
	virtual/perl-Module-Load
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
	virtual/perl-libnet
	app-admin/sudo
"

DEPEND="${ZM_DEPEND}"
RDEPEND="${ZM_DEPEND}"

if use cgi ; then
	need_httpd_cgi
	need_php_httpd
fi

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	if use cgi ; then
		webapp_pkg_setup
		require_php_with_use mysql sockets # instead of has_php
	fi
	if use daemon ; then
		enewgroup zoneminder # new user and group for zoneminder daemons
		enewuser zoneminder -1 -1 -1 zoneminder
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# epatch "${FILESDIR}/${P}-rundirdestdir.patch"
}

src_compile() {
	local myconf
	if use mmap ; then
		myconf="${myconf} --enable-mmap=yes"
	else
		myconf="${myconf} --enable-mmap=no"
	fi
	myconf="${myconf} --with-libarch=$(get_libdir)"
	myconf="${myconf} --with-mysql=/usr"
	myconf="${myconf} $(use_enable debug)"
	myconf="${myconf} $(use_enable debug crashtrace)"
	myconf="${myconf} $(use_with ffmpeg ffmpeg /usr)"
	if use cgi ; then
		myconf="${myconf} --with-webdir="${MY_HTDOCSDIR}""
		myconf="${myconf} --with-cgidir="${MY_CGIBINDIR}""
		myconf="${myconf} --with-webuser=nobody"
		myconf="${myconf} --with-webgroup=nobody"
	fi
	econf $myconf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	if use cgi ; then
		webapp_src_preinst
	fi

	keepdir /var/run/zm
	keepdir /var/log/${PN}

	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	if use daemon ; then
		newinitd "${FILESDIR}/init.d" zoneminder
		newconfd "${FILESDIR}/conf.d" zoneminder
	fi

	dodoc AUTHORS ChangeLog NEWS TODO

	insinto /etc
	doins "${FILESDIR}"/zm.conf

	insinto /usr/share/${PN}/db
	doins "${FILESDIR}"/db/zm_u* "${FILESDIR}/db/zm_create.sql"

	for DIR in events images sound; do
		dodir "${MY_HTDOCSDIR}/${DIR}"
	done

	if use cgi ; then
		webapp_postinst_txt en "${FILESDIR}/postinstall-en2.txt"
		webapp_src_install
	fi

	fperms 0644 /etc/zm.conf
}
