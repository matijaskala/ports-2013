# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="GNU Hurd"
HOMEPAGE="https://www.gnu.org/software/hurd/"
EGIT_REPO_URI="git://git.savannah.gnu.org/hurd/hurd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bzip2 headers-only ncurses parted zlib"
RESTRICT="mirror"

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] && [[ ${CATEGORY} == cross-* ]] ; then
	export CTARGET=${CATEGORY#cross-}
else
	export CTARGET=${CTARGET/x86_64/i686}
fi

COMMON_DEPEND="
	dev-libs/libgcrypt:=[static-libs(-)]
	bzip2? ( app-arch/bzip2[static-libs(+)] )
	ncurses? ( sys-libs/ncurses:=[static-libs] )
	parted? ( sys-apps/util-linux[static-libs(+)] sys-block/parted[static-libs(+)] )
	zlib? ( sys-libs/zlib[static-libs(+)] )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	app-shells/bash"

if [[ ${CHOST} != ${CTARGET} ]] ; then
	DEPEND="!headers-only? ( ${DEPEND} )"
	RDEPEND="!headers-only? ( ${RDEPEND} )"
fi

just_headers() {
	[[ ${CHOST} != ${CTARGET} ]] && use headers-only
}

alt_prefix() {
	[[ ${CHOST} != ${CTARGET} ]] && echo /usr/${CTARGET}
}

src_prepare() {
	eapply "${FILESDIR}"/lhurduser.diff
	eapply "${FILESDIR}"/MAKEDEV_null.diff
	default
	eautoreconf
}

src_configure() {
	just_headers || ./configure \
		--prefix="${ED}$(alt_prefix)" \
		--datadir="${ED}$(alt_prefix)/usr/share" \
		--datarootdir="${ED}$(alt_prefix)/usr/share" \
		--includedir="${ED}$(alt_prefix)/usr/include" \
		--libexecdir="${ED}$(alt_prefix)/usr/libexec" \
		--host=${CHOST} \
		--enable-static-progs=iso9660fs,ext2fs,ufs \
		--disable-profile \
		$(use_with parted) \
		$(use_with bzip2 libbz2) \
		$(use_with zlib libz) \
		$(use_enable ncurses ncursesw) \
		|| die
}

src_compile() {
	just_headers || default
}

src_install() {
	if just_headers ; then
		mkdir -p "${D}$(alt_prefix)${EPREFIX}/usr/include" || die
		emake \
			INSTALL_DATA="/bin/sh \"${S}\"/install-sh -c -C -m 644" DESTDIR="${ED}$(alt_prefix)" \
			includedir=/usr/include infodir=/usr/share/info \
			install-headers
		return
	fi

	emake install

	dodir $(alt_prefix)/usr/lib
	mv "${ED}$(alt_prefix)"/lib/lib*.a "${ED}$(alt_prefix)"/usr/lib || die

	local flags=( ${CFLAGS} ${LDFLAGS} -Wl,--verbose )
	if $(tc-getLD) --version | grep -q 'GNU gold' ; then
		local d="${T}/bfd-linker"
		mkdir -p "${d}"
		ln -sf $(which ${CHOST}-ld.bfd) "${d}"/ld
		flags+=( -B"${d}" )
	fi
	local output_format=$($(tc-getCC) "${flags[@]}" 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"
	for i in "${ED}$(alt_prefix)"/lib/*.so ; do
		local lib=${i#${ED}$(alt_prefix)/lib}
		cat > "${ED}$(alt_prefix)"/usr/lib/${lib} <<-END_LDSCRIPT
/* GNU ld script
   Since Gentoo has critical dynamic libraries in /lib, and the static versions
   in /usr/lib, we need to have a "fake" dynamic lib in /usr/lib, otherwise we
   run into linking problems.  This "fake" dynamic lib is a linker script that
   redirects the linker to the real lib.  And yes, this works in the cross-
   compiling scenario as the sysroot-ed linker will prepend the real path.

   See bug https://bugs.gentoo.org/4411 for more info.
 */
${output_format}
GROUP ( /lib/$(readlink "${i}") )
END_LDSCRIPT
		rm ${i} || die
		fperms a+x $(alt_prefix)/usr/lib/${lib} || die "could not change perms on ${lib}"
	done

	for i in login ps uptime vmstat w ; do
		rm "${ED}$(alt_prefix)"/bin/${i} || die
	done
	for i in fsck halt reboot ; do
		rm "${ED}$(alt_prefix)"/sbin/${i} || die
	done
}
