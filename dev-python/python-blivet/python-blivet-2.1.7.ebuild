# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit eutils distutils-r1

REAL_PN="${PN/python-}"

DESCRIPTION="python module for examining and modifying storage configuration."
HOMEPAGE="https://fedoraproject.org/wiki/Blivet"
SRC_URI="https://github.com/rhinstaller/${REAL_PN}/archive/${REAL_PN}-${PV}-1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=dev-util/pykickstart-1.99.22
	>=sys-apps/util-linux-2.15.1
	>=sys-block/parted-1.8.1
	sys-fs/cryptsetup
	sys-fs/mdadm
	sys-fs/dosfstools
	>=sys-fs/e2fsprogs-1.41.0
	sys-fs/btrfs-progs
	>=dev-python/pyblock-0.45
	sys-fs/multipath-tools
	sys-process/lsof
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${REAL_PN}-${REAL_PN}-${PV}-1"

src_prepare() {
	# libudev in Gentoo is in /usr/lib64 if systemd
	eapply "${FILESDIR}/${PN}-udev-path.patch"

	# multipath -c hangs on x86 due to a libc bug
	# Temporarily disable this
	use x86 && eapply "${FILESDIR}/${PN}-workaround-disable-multipath.patch"

	# Fix package names
	eapply "${FILESDIR}/0001-Update-package-names-to-reflect-Gentoo-ones.patch"
	# enable UUID= support for dm-based devices (dmcrypt, md, etc)
	eapply "${FILESDIR}/0001-devices-enable-UUID-for-dm-based-devices-in-fstab.patch"

	# Sabayon: commitToDisk should wait on udev. There is a missing udev_settle() call.
	eapply "${FILESDIR}/${PN}-commit-to-disk-settle.patch"

	distutils-r1_src_prepare
}
