# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools flag-o-matic

DESCRIPTION="Run executables under a new DBus session for testing"
HOMEPAGE="https://launchpad.net/dbus-test-runner"
MY_PV="${PV/_pre/+15.10.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

RDEPEND=">=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.34"
DEPEND="${RDEPEND}
	dev-util/intltool
	test? ( dev-util/bustle )"

src_prepare() {
	eautoreconf
	append-flags -Wno-error
}
