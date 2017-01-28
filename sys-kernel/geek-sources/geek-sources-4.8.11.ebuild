# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"
GEEK_SOURCES_IUSE="gentoo debian fedora mageia suse"

inherit geek-sources
detect_version

DESCRIPTION="Full sources for the Linux kernel including Gentoo, Debian, Fedora, Mageia and openSUSE patches"
HOMEPAGE="https://www.kernel.org"
UNIPATCH_LIST="${FILESDIR}/enable_additional_cpu_optimizations_for_gcc.patch ${FILESDIR}/linux-4.3-colored-printk.patch"

KEYWORDS="~amd64 ~x86"
DEBIAN_BRANCH="debian/${PV}-1"
DEBIAN_REPO_URI="git://anonscm.debian.org/kernel/linux.git -> ${DEBIAN_BRANCH}"
FEDORA_REPO_URI="git://pkgs.fedoraproject.org/kernel.git"
FEDORA_BRANCH="f23"
GENTOO_REPO_URI="git://anongit.gentoo.org/proj/linux-patches"
GENTOO_BRANCH="${KV_MAJOR}.${KV_MINOR}-${KV_PATCH}"
MAGEIA_REPO_URI="svn://svn.mageia.org/svn/packages/cauldron/kernel/releases/${PV}/1.mga6/PATCHES/patches -> mageia/${PV}"
SUSE_REPO_URI="git://kernel.opensuse.org/kernel-source.git"
SUSE_BRANCH="stable"

debian_apply() {
	cd debian/patches
	geek_apply `grep -ve '#' series`
}

fedora_apply() {
	geek_apply $(awk '/^Patch.*\.patch/{print $2}' kernel.spec)
}

gentoo_apply() {
	for i in * ; do
		[[ ${i:0:4} -ge 1500 ]] && [[ ${i:0:4} -lt 4600 ]] && geek_apply "$i"
	done
}

mageia_apply() {
	geek_apply `grep -ve '#' -ve '3rd' -ve 'mageia-logo' series`
}

suse_apply() {
	# masked arch.acpi.thermal because it is not compatible with linux 4.8.11
	# TODO remove the mask in later ebuilds
	geek_apply $(awk '!/(#|^$)/ && !/^(\+(needs|tren|trenn|hare|xen|jbeulich|jeffm|jjolly|agruen|still|philips|disabled|olh))|patches\.(kernel|rpmify|xen|arch.acpi.thermal).*/{gsub(/[ \t]/,"") ; print $1}' series.conf)
}
