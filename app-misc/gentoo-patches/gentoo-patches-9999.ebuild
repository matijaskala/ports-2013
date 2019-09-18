# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Patches for gentoo packages"
HOMEPAGE=""
EGIT_REPO_URI="https://github.com/matijaskala/gentoo-patches"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	insinto /etc/portage/patches
	doins -r *
}
