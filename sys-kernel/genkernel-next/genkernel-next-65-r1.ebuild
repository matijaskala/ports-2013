# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SRC_URI="https://github.com/Sabayon/genkernel-next/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha amd64 ~arm ia64 ppc ppc64 x86"
inherit bash-completion-r1

DESCRIPTION="Gentoo automatic kernel building scripts, reloaded"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"

IUSE="cryptsetup dmraid gpg iscsi mdadm plymouth selinux"
DOCS=( AUTHORS )
PATCHES=( "${FILESDIR}/multilive.patch" )

DEPEND="app-text/asciidoc
	sys-fs/e2fsprogs
	!sys-fs/eudev[-kmod,modutils]
	selinux? ( sys-libs/libselinux )"
RDEPEND="${DEPEND}
	!sys-kernel/genkernel
	cryptsetup? ( sys-fs/cryptsetup )
	dmraid? ( >=sys-fs/dmraid-1.0.0_rc16 )
	gpg? ( app-crypt/gnupg )
	iscsi? ( sys-block/open-iscsi )
	mdadm? ( sys-fs/mdadm )
	plymouth? ( sys-boot/plymouth )
	app-portage/portage-utils
	app-arch/cpio
	>=app-misc/pax-utils-0.6
	!<sys-apps/openrc-0.9.9
	sys-apps/util-linux
	sys-block/thin-provisioning-tools
	sys-fs/lvm2"

src_prepare() {
	default
	sed -i "/^GK_V=/ s:GK_V=.*:GK_V=${PV}:g" "${S}/genkernel" || \
		die "Could not setup release"

	sed -i "s:# CONFIG_RELAY is not set:CONFIG_RELAY=y:" "${S}"/arch/*/kernel-config || die
	sed -i "s:# CONFIG_ATH_COMMON is not set:CONFIG_ATH_COMMON=y:" "${S}"/arch/*/kernel-config || die
	sed -i "s:CONFIG_COMPAT_VDSO=y:# CONFIG_COMPAT_VDSO is not set:" "${S}"/arch/*/kernel-config || die
	for i in "${S}"/arch/*/kernel-config ; do
		cat >> "${i}" << EOF || die
CONFIG_ATH5K=m
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
CONFIG_ATH9K_RFKILL=y
CONFIG_CARL9170=m
CONFIG_ATH6KL=m
CONFIG_AR5523=m
CONFIG_WIL6210=m
CONFIG_ATH10K=m
CONFIG_ATH10K_PCI=m
CONFIG_SQUASHFS_XZ=y
EOF
	done
}

src_install() {
	default

	doman "${S}"/genkernel.8

	newbashcomp "${S}"/genkernel.bash genkernel
}
