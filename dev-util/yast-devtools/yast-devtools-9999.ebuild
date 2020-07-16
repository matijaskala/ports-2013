# Copyright 2014-2020 Matija Skala
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Scripts and templates for developing YaST2 modules and components."
EGIT_REPO_URI="https://github.com/yast/${PN}.git"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	default

	./build-tools/scripts/y2autoconf --bootstrap ./build-tools/ || die
	./build-tools/scripts/y2automake --bootstrap ./build-tools/ || die
	cat ./build-tools/aclocal/*.m4 > acinclude.m4
	eautoreconf
}
