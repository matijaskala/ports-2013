# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"

inherit geek-sources
detect_version

DESCRIPTION="Full sources for the Linux kernel including Fedora patches"
HOMEPAGE="https://src.fedoraproject.org/cgit/rpms/kernel.git"

KEYWORDS="~amd64 ~x86"
FEDORA_SRC="git://pkgs.fedoraproject.org/kernel.git"

src_unpack() {
	kernel-2_src_unpack

	geek_prepare_storedir

	local CSD="${GEEK_STORE_DIR}/fedora"
	if [ -d "${CSD}" ] ; then
		cd "${CSD}" || die "cd ${CSD} failed"
		[ -e .git ] && git pull --all --quiet
	else
		git clone --depth=1 -b f23 "${FEDORA_SRC}" "${CSD}"
		cd "${CSD}" || die "cd ${CSD} failed"
	fi

	cd "${S}" || die "cd ${S} failed"

	for i in $(awk '/^Patch.*\.patch/{print $2}' "${CSD}"/kernel.spec) ; do
		ebegin "Applying $i"
		patch -f -p1 -r - -s < "${GEEK_STORE_DIR}/fedora/$i"
		eend $?
	done
}
