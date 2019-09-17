# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit eutils multilib perl-module multilib-minimal

# cvs -d anoncvs@anoncvs.openbsd.org:/cvs get src/usr.bin/pkg-config

PKG_M4_VERSION=0.28

DESCRIPTION="A perl based version of pkg-config from OpenBSD"
HOMEPAGE="http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/usr.bin/pkg-config/"
SRC_URI="https://github.com/matijaskala/${PN}/archive/32fa6a04409790a3a6c6c281cbd7bd3c1829c83b.tar.gz -> ${P}.tar.gz
	pkg-config? ( https://pkgconfig.freedesktop.org/releases/pkg-config-${PKG_M4_VERSION}.tar.gz )"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pkg-config"

RDEPEND="virtual/perl-Getopt-Long
	pkg-config? (
		!dev-util/pkgconfig
		!dev-util/pkgconf[pkg-config]
	)"

S=${WORKDIR}/${PN}-32fa6a04409790a3a6c6c281cbd7bd3c1829c83b

src_prepare() {
	epatch_user
	ecvs_clean

	# Config.pm from dev-lang/perl doesn't set ARCH, only archname
	sed -i -e '/Config/s:ARCH:archname:' pkg-config || die

	if use pkg-config; then
		MULTILIB_CHOST_TOOLS=( /usr/bin/pkg-config )
	else
		MULTILIB_CHOST_TOOLS=( /usr/bin/pkg-config-openbsd )
	fi
}

multilib_src_install() {
	local pc_bin=pkg-config
	use pkg-config || pc_bin+=-openbsd

	newbin "${S}"/pkg-config ${pc_bin}
	newman "${S}"/pkg-config.1 ${pc_bin}.1

	# insert proper paths
	local pc_paths=(
		/usr/$(get_libdir)/pkgconfig
		/usr/share/pkgconfig
	)
	sed -i -e "/my @PKGPATH/,/;/{s@(.*@( ${pc_paths[*]} );@p;d}" \
		"${ED%/}/usr/bin/${pc_bin}" || die
}

multilib_src_install_all() {
	if use pkg-config; then
		insinto /usr/share/aclocal
		doins "${WORKDIR}"/pkg-config-*/pkg.m4
	fi

	perl_set_version
	insinto "${VENDOR_LIB}"
	doins -r "${S}"/OpenBSD
}
