# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libbluray/libbluray-9999.ebuild,v 1.16 2014/04/28 18:04:46 mgorny Exp $

EAPI=5

inherit autotools java-pkg-opt-2 git-r3 flag-o-matic eutils multilib-minimal
EGIT_REPO_URI="git://git.videolan.org/libbluray.git"

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="http://www.videolan.org/developers/libbluray.html"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="aacs java static-libs +truetype utils +xml"

COMMON_DEPEND="
	xml? ( dev-libs/libxml2[${MULTILIB_USEDEP}] )
	truetype? ( media-libs/freetype:2[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${COMMON_DEPEND}
	aacs? ( media-libs/libaacs[${MULTILIB_USEDEP}] )
	java? ( >=virtual/jre-1.6 )
"
DEPEND="
	${COMMON_DEPEND}
	java? (
		>=virtual/jdk-1.6
		dev-java/ant-core
	)
	virtual/pkgconfig
"

DOCS=( ChangeLog README.txt )

src_prepare() {
	if use java ; then
		export JDK_HOME="$(java-config -g JAVA_HOME)"

		# don't install a duplicate jar file
		sed -i '/^jar_DATA/d' src/Makefile.am || die

		java-pkg-opt-2_src_prepare
	fi
	eautoreconf
}

multilib_src_configure() {
	local myconf
	if multilib_is_native_abi && use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		append-cflags "$(java-pkg_get-jni-cflags)"
		myconf="--enable-bdjava"
	else
		myconf="--disable-bdjava"
	fi

	ECONF_SOURCE="${S}" econf \
		--disable-optimizations \
		$(multilib_native_use_enable utils examples) \
		$(use_with truetype freetype) \
		$(use_enable static-libs static) \
		$(use_with xml libxml2) \
		${myconf}
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use utils; then
		cd src
		dobin index_dump mobj_dump mpls_dump
		cd .libs/
		dobin bd_info bdsplice clpi_dump hdmv_test libbluray_test list_titles sound_dump
		if use java; then
			dobin bdj_test
		fi
	fi

	if multilib_is_native_abi && use java; then
		java-pkg_dojar "${BUILD_DIR}"/src/.libs/${PN}.jar
		doenvd "${FILESDIR}"/90${PN}
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
