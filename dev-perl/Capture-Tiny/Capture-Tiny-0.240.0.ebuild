# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Capture-Tiny/Capture-Tiny-0.240.0.ebuild,v 1.14 2014/04/26 09:16:44 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.24
inherit perl-module

DESCRIPTION="Capture STDOUT and STDERR from Perl, XS or external programs"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="test"

DEPEND="
	test? (
		dev-perl/Inline
	)
"

SRC_TEST=do
