# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SNMP_Session/SNMP_Session-1.13.ebuild,v 1.11 2013/08/26 15:29:56 idella4 Exp $

inherit perl-module

DESCRIPTION="A SNMP Perl Module"
SRC_URI="http://snmp-session.googlecode.com/files/${P}.tar.gz"
HOMEPAGE="http://code.google.com/p/snmp-session/"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~sparc-solaris ~x86-solaris"
IUSE=""
SRC_TEST="do"

mydoc="README.SNMP_util"

src_install() {
	perl-module_src_install
	dohtml *.html
}
