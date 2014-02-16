# Copyright 2014 Matija Skala
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit yast

DESCRIPTION="Scripts and templates for developing YaST2 modules and components."

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	./build-tools/scripts/y2autoconf --bootstrap ./build-tools/
	./build-tools/scripts/y2automake --bootstrap ./build-tools/
	cat ./build-tools/aclocal/*.m4 > acinclude.m4
	eautoreconf
}
