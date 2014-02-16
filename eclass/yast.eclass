# Copyright 2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools git-r3

EXPORT_FUNCTIONS src_prepare

EGIT_REPO_URI="git://github.com/yast/${PN}.git"

yast_src_prepare() {
    y2tool --prefix /usr y2autoconf
    y2tool --prefix /usr y2automake
    eautoreconf
}
