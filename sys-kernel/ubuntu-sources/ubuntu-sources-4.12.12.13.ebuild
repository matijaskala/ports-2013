# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"

inherit versionator
OKV=$(get_version_component_range 1-2)
inherit mount-boot kernel-2
detect_version

KCONFIG_URELEASE="utopic"
KCONFIG_URELEASE="artful/linux/${OKV}.0-$(get_version_component_range 3-4)"
UBUNTU_PATCH="linux_${OKV}.0-$(get_version_component_range 3-4).diff.gz"
UBUNTU_URI="http://archive.ubuntu.com/ubuntu/pool/main/l/linux/${UBUNTU_PATCH}"
UNIPATCH_LIST="${DISTDIR}/${UBUNTU_PATCH}"

DESCRIPTION="Ubuntu patched kernel sources"
HOMEPAGE="https://launchpad.net/ubuntu/+source/linux"
SRC_URI="${KERNEL_URI} ${UBUNTU_URI}
	amd64? ( http://kernel.ubuntu.com/~kernel-ppa/config/${KCONFIG_URELEASE}/amd64-config.flavour.generic -> amd64-config-ubuntu-${PV} )
	x86? ( http://kernel.ubuntu.com/~kernel-ppa/config/${KCONFIG_URELEASE}/i386-config.flavour.generic -> i386-config-ubuntu-${PV} )"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="binary"
RESTRICT="binchecks mirror strip"
DEPEND="binary? ( >=sys-kernel/genkernel-3.4.12.6-r4 )"
RDEPEND="binary? ( virtual/udev )"

pkg_setup() {
	case $ARCH in
		i386)
			defconfig_src=i386
			;;
		amd64)
			defconfig_src=amd64
			;;
		*)
			die "unsupported ARCH: $ARCH"
			;;
	esac
	defconfig_src="${DISTDIR}/${defconfig_src}-config-ubuntu-${PV}"
	unset ARCH; unset LDFLAGS # will interfere with Makefile if set
}

src_prepare() {
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${EXTRAVERSION}:" Makefile || die
	sed	-i -e 's:#export\tINSTALL_PATH:export\tINSTALL_PATH:' Makefile || die
	rm -f .config >/dev/null

	# Ubuntu:
	install -d ${TEMP}/configs || die
	make -s mrproper || die "make mrproper failed"

	mv "${TEMP}/configs" "${S}" || die
}

src_compile() {
	use binary || return
	install -d "${WORKDIR}"/out/{lib,boot}
	install -d "${T}"/{cache,twork}
	install -d "${WORKDIR}"/build
	DEFAULT_KERNEL_SOURCE="${S}" CMD_KERNEL_DIR="${S}" genkernel ${GKARGS} \
		--no-save-config \
		--kernel-config="$defconfig_src" \
		--kernname="${PN}" \
		--build-src="${S}" \
		--build-dst="${WORKDIR}"/build \
		--makeopts="${MAKEOPTS}" \
		--cachedir="${T}"/cache \
		--tempdir="${T}"/twork \
		--logfile="${WORKDIR}"/genkernel.log \
		--bootdir="${WORKDIR}"/out/boot \
		--luks \
		--iscsi \
		--module-prefix="${WORKDIR}"/out \
		all || die "genkernel failed"
}

src_install() {
	kernel-2_src_install

	cd "${ED}usr/src/linux-${KV_FULL}"

	# prepare for real-world use and 3rd-party module building:
	make mrproper || die
	cp "$defconfig_src" .config || die
	yes "" | make oldconfig || die
	# if we didn't use genkernel, we're done. The kernel source tree is left in
	# an unconfigured state - you can't compile 3rd-party modules against it yet.
	use binary || return
	make prepare || die
	make scripts || die
	# Now the source tree is configured to allow 3rd-party modules to be
	# built against it, since we want that to work since we have a binary kernel
	# built.
	cp -a "${WORKDIR}"/out/* "${ED}" || die "couldn't copy output files into place"

	# module symlink fixup:
	rm -f "${ED}"/lib/modules/*/source || die
	rm -f "${ED}"/lib/modules/*/build || die
	cd "${ED}"/lib/modules
	# module strip:
	find -iname *.ko -exec strip --strip-debug {} \;
	# back to the symlink fixup:
	local moddir="$(ls -d [234]*)"
	ln -s /usr/src/linux-${KV_FULL} "${ED}"/lib/modules/${moddir}/source || die
	ln -s /usr/src/linux-${KV_FULL} "${ED}"/lib/modules/${moddir}/build || die

	# Fixes FL-14
	cp "${WORKDIR}/build/System.map" "${ED}/usr/src/linux-${KV_FULL}" || die
	cp "${WORKDIR}/build/Module.symvers" "${ED}/usr/src/linux-${KV_FULL}" || die
}
