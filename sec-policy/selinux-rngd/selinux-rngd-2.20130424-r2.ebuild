# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-rngd/selinux-rngd-2.20130424-r2.ebuild,v 1.1 2013/12/16 14:40:39 swift Exp $
EAPI="4"

IUSE=""
MODS="rngd"
BASEPOL="2.20130424-r2"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for rngd"

KEYWORDS="amd64 x86"
