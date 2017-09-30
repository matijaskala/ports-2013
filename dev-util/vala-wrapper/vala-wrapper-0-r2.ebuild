# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Wrapper for Vala that picks the latest Vala version"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="!app-admin/eselect-vala
	app-portage/portage-utils
	dev-lang/vala"

S=${WORKDIR}

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}"/vala-wrapper
	for i in vala valac vala-gen-introspect vapicheck vapigen ; do
		dosym vala-wrapper /usr/bin/$i
	done
}
