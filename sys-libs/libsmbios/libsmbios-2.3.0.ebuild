# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic python-single-r1

DESCRIPTION="Provide access to (SM)BIOS information"
HOMEPAGE="http://linux.dell.com/libsmbios/main/index.html"
SRC_URI="http://linux.dell.com/libsmbios/download/libsmbios/${P}/${P}.tar.xz
	http://linux.dell.com/libsmbios/download/libsmbios/old/${P}/${P}.tar.xz"

LICENSE="GPL-2 OSL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="doc graphviz nls python static-libs test"

RDEPEND="dev-libs/libxml2
	sys-libs/zlib
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	graphviz? ( media-gfx/graphviz )
	nls? ( sys-devel/gettext )
	test? ( >=dev-util/cppunit-1.9.6 )"

PATCHES=(
	"${FILESDIR}/${PN}-fix-pie.patch"
	"${FILESDIR}/${PN}-2.2.28-cppunit-tests.patch"
	"${FILESDIR}/${PN}-2.3.0-doxygen_target.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	>pkg/py-compile

	eautoreconf
}

src_configure() {
	#Remove -O3 for bug #290097
	replace-flags -O3 -O2

	econf \
		$(use_enable doc doxygen) \
		$(use_enable graphviz) \
		$(use_enable nls) \
		$(use_enable python) \
		$(use_enable static-libs static)
}

src_install() {
	emake install DESTDIR="${D}"

	rm -r "${D}etc/yum" || die
	rm -r "${D}usr/lib/yum-plugins" || die
	if ! use python ; then
		rmdir "${D}libsmbios_c" "${D}usr/share/smbios-utils" || die
		rm -r "${D}etc" || die
	else
		local python_scriptroot="/usr/sbin"
		python_doscript "${D}"/usr/sbin/smbios-{lcd-brightness,passwd,rbu-bios-update,sys-info,token-ctl,wakeup-ctl,wireless-ctl}
	fi

	insinto /usr/include/
	doins -r src/include/smbios/

	dodoc AUTHORS ChangeLog NEWS README TODO

	use static-libs || prune_libtool_files --all
}
