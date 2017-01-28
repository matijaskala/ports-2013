# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: geek-sources.eclass
# @MAINTAINER:
# Matija Skala <mskala@gmx.com>
# @AUTHOR:
# Matija Skala <mskala@gmx.com>
# @BLURB: Eclass for geek-sources
# @DESCRIPTION:
# This eclass applies the patches for geek-sources

inherit geek kernel-2

EXPORT_FUNCTIONS src_unpack

SRC_URI="${KERNEL_URI}"
IUSE="${GEEK_SOURCES_IUSE}"

geek-sources_src_unpack() {
	kernel-2_src_unpack

	geek_prepare_storedir

	for i in ${GEEK_SOURCES_IUSE} ; do
		use ${i} || continue
		if type "${i}_fetch" &> /dev/null ; then
			"${i}_fetch"
		else
			geek_fetch ${i}
		fi
		pushd "$(geek_get_source_repo_path "${i}")" > /dev/null || die
		GEEK_SOURCE_REPO=${i} ${i}_apply
		popd > /dev/null || die
	done
}
