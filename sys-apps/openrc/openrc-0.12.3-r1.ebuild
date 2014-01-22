# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic multilib pam toolchain-funcs

DESCRIPTION="OpenRC manages the services, startup and shutdown of a host"
HOMEPAGE="http://roy.marples.name/openrc"
RESTRICT="mirror"

LICENSE="BSD-2"
SLOT="0"
IUSE="debug elibc_glibc ncurses pam prefix selinux static-libs
	unicode kernel_linux kernel_FreeBSD"
KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

COMMON_DEPEND=">=sys-apps/baselayout-2.1-r1
	kernel_FreeBSD? ( || ( >=sys-freebsd/freebsd-ubin-9.0_rc sys-process/fuser-bsd ) )
	elibc_glibc? ( >=sys-libs/glibc-2.5 )
	ncurses? ( sys-libs/ncurses )
	pam? ( sys-auth/pambase )
	selinux? ( sec-policy/selinux-openrc )
	!<sys-fs/udev-init-scripts-17
	!<sys-fs/udev-133"
DEPEND="${COMMON_DEPEND}
	virtual/os-headers
	ncurses? ( virtual/pkgconfig )"
RDEPEND="${COMMON_DEPEND}
	sys-apps/iproute2
	!prefix? (
		kernel_linux? ( || ( >=sys-apps/sysvinit-2.86-r6 sys-process/runit ) )
		kernel_FreeBSD? ( sys-freebsd/freebsd-sbin )
	)"

GITHUB_REPO="${PN}"
GITHUB_USER="funtoo"
GITHUB_TAG="funtoo-${P}-r0"
NETV="1.3.8"
GITHUB_REPO_CN="corenetwork"
GITHUB_TAG_CN="$NETV"

SRC_URI="
	https://www.github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/${GITHUB_TAG} -> ${PN}-${GITHUB_TAG}.tar.gz
	https://www.github.com/${GITHUB_USER}/${GITHUB_REPO_CN}/tarball/${GITHUB_TAG_CN} -> corenetwork-${NETV}.tar.gz
	"

src_prepare() {
	sed -i 's:0444:0644:' mk/sys.mk || die

	if [[ ${PV} == "9999" ]] ; then
		local ver="git-${EGIT_VERSION:0:6}"
		sed -i "/^GITVER[[:space:]]*=/s:=.*:=${ver}:" mk/git.mk || die
	fi

	# Allow user patches to be applied without modifying the ebuild
	epatch_user
}

make_args() {
	unset LIBDIR #266688

	MAKE_ARGS="${MAKE_ARGS}
		LIBNAME=$(get_libdir)
		LIBEXECDIR=${EPREFIX}/$(get_libdir)/rc
		MKSELINUX=$(usex selinux)
		MKSTATICLIBS=$(usex static-libs)
	MKNET=no"

	local brand="Unknown"
	if use kernel_linux ; then
		MAKE_ARGS="${MAKE_ARGS} OS=Linux"
		brand="Linux"
	elif use kernel_FreeBSD ; then
		MAKE_ARGS="${MAKE_ARGS} OS=FreeBSD"
		brand="FreeBSD"
	fi
	export BRANDING="Party ${brand}"
	use prefix && MAKE_ARGS="${MAKE_ARGS} MKPREFIX=yes PREFIX=${EPREFIX}"
	export DEBUG=$(usev debug)
	export MKPAM=$(usev pam)
	export MKTERMCAP=$(usev ncurses)
}

src_unpack() {
	unpack $A
	# rename github directories to the names we're expecting:
	local old=${WORKDIR}/${GITHUB_USER}-${PN}-*
	mv $old "${WORKDIR}/${P}" || die "move fail 1"
	old="${WORKDIR}/${GITHUB_USER}-corenetwork-*"
	mv $old "${WORKDIR}/corenetwork-${NETV}" || die "move fail 2"
}

src_compile() {
	make_args

	tc-export CC AR RANLIB
	emake ${MAKE_ARGS}
}

# set_config <file> <option name> <yes value> <no value> test
# a value of "#" will just comment out the option
set_config() {
	local file="${ED}/$1" var=$2 val com
	eval "${@:5}" && val=$3 || val=$4
	[[ ${val} == "#" ]] && com="#" && val='\2'
	sed -i -r -e "/^#?${var}=/{s:=([\"'])?([^ ]*)\1?:=\1${val}\1:;s:^#?:${com}:}" "${file}"
}

set_config_yes_no() {
	set_config "$1" "$2" YES NO "${@:3}"
}

src_install() {
	make_args
	emake ${MAKE_ARGS} DESTDIR="${D}" install

	# move the shared libs back to /usr so ldscript can install
	# more of a minimal set of files
	# disabled for now due to #270646
	#mv "${ED}"/$(get_libdir)/lib{einfo,rc}* "${ED}"/usr/$(get_libdir)/ || die
	#gen_usr_ldscript -a einfo rc
	gen_usr_ldscript libeinfo.so
	gen_usr_ldscript librc.so

	if ! use kernel_linux; then
		keepdir /$(get_libdir)/rc/init.d
	fi
	keepdir /$(get_libdir)/rc/tmp

	# Backup our default runlevels
	dodir /usr/share/"${PN}"
	cp -PR "${ED}"/etc/runlevels "${ED}"/usr/share/${PN} || die
	rm -rf "${ED}"/etc/runlevels

	# Setup unicode defaults for silly unicode users
	set_config_yes_no /etc/rc.conf unicode use unicode

	# Cater to the norm
	set_config_yes_no /etc/conf.d/keymaps windowkeys '(' use x86 '||' use amd64 ')'

	# On HPPA, do not run consolefont by default (bug #222889)
	if use hppa; then
		rm -f "${ED}"/usr/share/openrc/runlevels/boot/consolefont
	fi

	# Support for logfile rotation
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openrc.logrotate openrc

	# install the gentoo pam.d file
	newpamd "${FILESDIR}"/start-stop-daemon.pam start-stop-daemon

	# install documentation
	dodoc README.busybox
	if use newnet; then
		dodoc README.newnet
	fi

	# Install funtoo networking parts:

	cd ${WORKDIR}/corenetwork-${NETV} || die
	dodoc docs/index.rst || die
	exeinto /etc/init.d || die
	doexe init.d/{netif.tmpl,netif.lo} || die
	cp -a netif.d ${D}/etc || die
	chown -R root:root ${D}/etc/netif.d || die
	chmod 0755 ${D}/etc/netif.d || die
	chmod -R 0644 ${D}/etc/netif.d/* || die
	ln -s /etc/init.d/netif.lo ${D}/usr/share/openrc/runlevels/sysinit/netif.lo || die
}

add_boot_init() {
	local initd=$1
	local runlevel=${2:-boot}
	# if the initscript is not going to be installed and is not
	# currently installed, return
	[[ -e "${ED}"/etc/init.d/${initd} || -e "${EROOT}"etc/init.d/${initd} ]] \
		|| return
	[[ -e "${EROOT}"etc/runlevels/${runlevel}/${initd} ]] && return

	# if runlevels dont exist just yet, then create it but still flag
	# to pkg_postinst that it needs real setup #277323
	if [[ ! -d "${EROOT}"etc/runlevels/${runlevel} ]] ; then
		mkdir -p "${EROOT}"etc/runlevels/${runlevel}
		touch "${EROOT}"etc/runlevels/.add_boot_init.created
	fi

	elog "Auto-adding '${initd}' service to your ${runlevel} runlevel"
	ln -snf /etc/init.d/${initd} "${EROOT}"etc/runlevels/${runlevel}/${initd}
}

pkg_postinst() {
	local runl
	local LIBDIR=$(get_libdir)
	install -d -m0755 ${ROOT}/etc/runlevels
	local runldir="${ROOT}usr/share/openrc/runlevels"

	# Remove old baselayout links
	rm -f "${ROOT}"/etc/runlevels/boot/{check{fs,root},rmnologin}
	rm -f "${ROOT}"/etc/init.d/{depscan,runscript}.sh
	rm -f "${ROOT}"/etc/runlevels/boot/netif.lo

	# CREATE RUNLEVEL DIRECTORIES
	# ===========================

	# To ensure proper system operation, this portion of the script ensures that
	# all of OpenRC's default initscripts in all runlevels are properly
	# installed.

	for runl in $( cd "$runldir"; echo * )
	do
		einfo "Processing $runl..."
		einfo "Ensuring runlevel $runl has all required scripts..."
		for initd in $( cd "$runldir/$runl"; echo * ); do
			add_boot_init ${initd} $runl
		done
	done

	# Rather than try to migrate everyone using complex scripts, simply print
	# names of initscripts that are in the user's runlevels but not provided by
	# OpenRC. This loop can be upgraded to look for particular scripts that
	# might have come from baselayout.

	for runl in $( cd ${ROOT}/etc/runlevels; echo * )
	do
		[ ! -d ${runldir}/${runl} ] && continue
		for init in $( cd "$runldir/$runl"; echo * )
		do
			if [ -e ${ROOT}/etc/runlevels/${runl}/${init} ] && [ ! -e ${runldir}/${runl}/${init} ]
			then
				echo "Initscript ${init} exists in runlevel ${runl} but not in OpenRC."
			fi
		done
	done

	chmod +x ${ROOT}/etc/netif.d

	# OTHER STUFF
	# ===========

	# update the dependency tree after touching all files #224171
	[[ "${EROOT}" = "/" ]] && "${EROOT}/${LIBDIR}"/rc/bin/rc-depend -u

	elog "You should now update all files in /etc, using etc-update"
	elog "or equivalent before rebooting."
	elog

	if path_exists -o "${ROOT}"/etc/conf.d/local.{start,stop} ; then
		ewarn "/etc/conf.d/local.{start,stop} are deprecated.  Please convert"
		ewarn "your files to /etc/conf.d/local and delete the files."
	fi

	ewarn "Make sure that correct symlink exist"
	ewarn "Re-establish it by ln -s /etc/init.d/netif.tmpl /etc/init.d/netif.ethX"
}
