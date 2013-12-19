# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/popfile/popfile-1.1.3.ebuild,v 1.1 2013/12/16 07:06:16 patrick Exp $

EAPI=2
inherit eutils

DESCRIPTION="Anti-spam bayesian filter"
HOMEPAGE="http://getpopfile.org"
SRC_URI="http://getpopfile.org/downloads/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk ipv6 mysql ssl xmlrpc"

RDEPEND="virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
	dev-perl/DBD-SQLite
	dev-perl/HTML-Tagset
	dev-perl/HTML-Template
	dev-perl/TimeDate
	dev-perl/DBI
	perl-core/digest-base
	perl-core/Digest-MD5
	cjk? ( dev-perl/Encode-compat
		dev-perl/Text-Kakasi )
	mysql? ( dev-perl/DBD-mysql	)
	ipv6? ( dev-perl/IO-Socket-INET6 )
	ssl? ( dev-libs/openssl
		dev-perl/IO-Socket-SSL
		dev-perl/Net-SSLeay )
	xmlrpc? ( dev-perl/PlRPC )"

DEPEND="app-arch/unzip"

src_prepare() {
	local f
	for f in `find ./ -type f`; do
		edos2unix "${f}"
	done
}

src_install() {
	dodoc *.change*
	rm -rf *.change* license

	insinto /usr/share/${PN}
	doins -r * || die

	fperms 755 /usr/share/${PN}/{popfile,insert,pipe,bayes}.pl

	dosbin "${FILESDIR}"/${PN} || die
}
