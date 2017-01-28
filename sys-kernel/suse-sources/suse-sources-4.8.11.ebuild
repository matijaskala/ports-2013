# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"

inherit geek-sources
detect_version

DESCRIPTION="Full sources for the Linux kernel including openSUSE patches"
HOMEPAGE="https://kernel.opensuse.org"

KEYWORDS="~amd64 ~x86"
SUSE_SRC="git://kernel.opensuse.org/kernel-source.git"
SUSE_BRANCH="stable"

src_unpack() {
	kernel-2_src_unpack

	geek_prepare_storedir

	local CSD="${GEEK_STORE_DIR}/suse"
	if [ -d "${CSD}" ] ; then
		cd "${CSD}" || die "cd ${CSD} failed"
		[ -e .git ] && git pull --all --quiet
	else
		git clone -b "${SUSE_BRANCH}" "${SUSE_SRC}" "${CSD}"
		cd "${CSD}" || die "cd ${CSD} failed"
	fi

	cd "${S}" || die "cd ${S} failed"

	for i in $(awk '!/(#|^$)/ && !/^(\+(needs|tren|trenn|hare|xen|jbeulich|jeffm|jjolly|agruen|still|philips|disabled|olh))|patches\.(kernel|rpmify|xen|arch.acpi.thermal).*/{gsub(/[ \t]/,"") ; print $1}' ${CSD}/series.conf) ; do
		ebegin "Applying $i"
		patch -f -r - -p1 -s < "${CSD}/$i"
		eend $?
	done
}
