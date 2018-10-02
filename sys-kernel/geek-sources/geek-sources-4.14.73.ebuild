# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
ETYPE="sources"
GEEK_SOURCES_IUSE="+gentoo debian fedora mageia suse"

inherit geek-sources
detect_version

DESCRIPTION="Full sources for the Linux kernel including Gentoo, Debian, Fedora, Mageia and openSUSE patches"
HOMEPAGE="https://www.kernel.org"
UNIPATCH_LIST="${FILESDIR}/5020_enable-additional-cpu-optimizations-for-gcc-4.14.patch ${FILESDIR}/linux-4.14-colored-printk.patch"
UNIPATCH_STRICTORDER=1

KEYWORDS="~amd64 ~x86"
DEBIAN_BRANCH="debian/${PV}-1"
DEBIAN_REPO_URI="git://anonscm.debian.org/kernel/linux.git -> ${DEBIAN_BRANCH}"
FEDORA_BRANCH="f24"
FEDORA_REPO_URI="git://pkgs.fedoraproject.org/kernel.git -> fedora/${FEDORA_BRANCH}"
GENTOO_REPO_URI="git://anongit.gentoo.org/proj/linux-patches"
GENTOO_BRANCH="${KV_MAJOR}.${KV_MINOR}-${KV_PATCH}"
MAGEIA_REPO_URI="svn://svn.mageia.org/svn/packages/cauldron/kernel/releases/4.14.44/2.mga7/PATCHES/patches -> mageia/4.14.44"
SUSE_REPO_URI="git://kernel.opensuse.org/kernel-source.git"
SUSE_BRANCH="stable"
IUSE="bfq muqss wbt zen-interactive"
REQUIRED_USE="zen-interactive? ( muqss )"

debian_fetch() {
	local CSD="$(geek_get_source_repo_path debian)"
	if [[ -d ${CSD} ]]; then
		pushd "${CSD}" > /dev/null || die
		git pull --all --quiet
		popd > /dev/null || die
	else
		git clone -b "${DEBIAN_BRANCH}" "${DEBIAN_REPO_URI% -> *}" "${CSD}"
	fi
}

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
	geek_apply `grep -ve '#' -ve '3rd' -ve 'fs-aufs' -ve 'mageia-logo' series`
}

suse_apply() {
	geek_apply $(awk '!/(#|^$)/ && !/^(\+(needs|tren|trenn|hare|xen|jbeulich|jeffm|jjolly|agruen|still|philips|disabled|olh))|patches\.(kernel|rpmify|suse|xen).*/{gsub(/[ \t]/,"") ; print $1}' series.conf)
}

src_unpack() {
	use muqss && UNIPATCH_LIST+=" ${FILESDIR}/0001-MuQSS-The-Multiple-Queue-Skiplist-Scheduler-v0.144-b.patch"
	use wbt && UNIPATCH_LIST+=" ${FILESDIR}/0002-Writeback-buf-throttling-patch-v7-by-Jens-Axboe.patch"
	use bfq && UNIPATCH_LIST+=" ${FILESDIR}/0003-BFQ-version-4.8.0-v8r5-by-Paolo-Valente.patch"
	use zen-interactive && UNIPATCH_LIST+=" ${FILESDIR}/zen_interactive.patch"

	geek-sources_src_unpack
}
