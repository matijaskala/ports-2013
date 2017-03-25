# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

COREUTILS_BIN="cat chgrp chmod chown cp date dd df echo false ln ls mkdir mknod mv pwd rm rmdir stty sync true uname"
# busybox puts 'nice' and 'stat' into /bin - let's follow their decision, even if we don't have to...
COREUTILS_BIN="${COREUTILS_BIN} mktemp nice sleep stat touch"
COREUTILS_USR_BIN="${COREUTILS_BIN} [ cksum comm expand id install md5sum nohup printf realpath sha1sum sha3sum sha256sum sha512sum shuf split sum tac tee timeout truncate unexpand uniq unlink users who whoami"
# FIXME: should the following go to /bin?
COREUTILS_USR_BIN="${COREUTILS_USR_BIN} basename cut dirname du env expr head less man mkfifo readlink seq sort tail tr tty wc yes"
COREUTILS_USR_SBIN="chroot"

GZIP_BIN="gzip gunzip uncompress zcat"
KBD_USR_BIN="chvt deallocvt fgconsole openvt setkeycodes showkey"
KMOD_SBIN="depmod insmod lsmod modinfo modprobe rmmod"
PROCPS_USR_BIN="free pgrep pidof pkill pmap pwdx top uptime watch"
XZ_USR_BIN="lzcat lzma unlzma unxz xz xzcat"

APPLETS_BIN="${COREUTILS_BIN} ${GZIP_BIN} catv chattr cpio dmesg dnsdomainname ed egrep fgrep fuser grep hostname kill linux32 linux64 login lsattr lzop more mount mountpoint netstat pidof ping ps sed setarch su tar umount watch"
APPLETS_SBIN="${KMOD_SBIN} acpid arp blkid blockdev findfs fsck hwclock ifconfig ip iptunnel losetup mkdosfs mke2fs mkfs.ext2 mkfs.vfat mkswap nameif pivot_root route swapoff swapon switch_root sysctl tune2fs"
APPLETS_USR_BIN="${COREUTILS_USR_BIN} ${PROCPS_USR_BIN} ${KBD_USR_BIN} ${XZ_USR_BIN} bunzip2 bzcat bzip2 cal cmp diff find flock groups hexdump killall last lpq lpr lsof lspci lsusb lzopcat mkpasswd nslookup passwd patch pstree resize script setarch traceroute unlzop wget which whois xargs"
APPLETS_USR_SBIN="${COREUTILS_USR_SBIN} addgroup adduser chat chpasswd crond delgroup deluser sendmail setfont tftpd"
APPLETS_ALL="${APPLETS_BIN} ${APPLETS_SBIN} ${APPLETS_USR_BIN} ${APPLETS_USR_SBIN}"

DESCRIPTION="Wrappers around busybox applets"
HOMEPAGE="https://www.busybox.net/"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="${APPLETS_ALL} dir groupadd useradd vdir"

DEPEND="sys-apps/busybox[-make-symlinks(-)]"
RDEPEND="${DEPEND}"

provided_by() {
	local _pkgs=()
	local _liuse=( ${IUSE} )
	while [[ ${1} != *: ]] ; do
		_pkgs+=("${1}")
		shift
	done
	if [[ -n ${1%:} ]] ; then
		_pkgs+=("${1%:}")
		shift
	fi
	for _useflag in $( ( for i ; do echo $i ; done ) | /bin/grep -v -e '\[' -e '\.' | sort -u ) ; do
		if has "${_useflag}" "${_liuse[@]#[+-]}" ; then
			RDEPEND+=" ${_useflag}? ("
			for _pkg in "${_pkgs[@]}" ; do
				RDEPEND+=" !${_pkg}"
			done
			RDEPEND+=" )"
		fi
	done
}

they_all_provide() {
	local _useflag=${1%:}
	local _liuse=( ${IUSE} )
	shift
	if has "${_useflag}" "${_liuse[@]#[+-]}" ; then
		RDEPEND+=" ${_useflag}? ("
		for _pkg ; do
			RDEPEND+=" !${_pkg}"
		done
		RDEPEND+=" )"
	fi
}

provided_by app-arch/cpio: cpio
provided_by app-arch/bzip2: bunzip2 bzcat bzip2
provided_by app-arch/gzip: ${GZIP_BIN}
provided_by app-arch/lzop: lzop
provided_by app-arch/xz-utils: ${XZ_USR_BIN}
provided_by app-arch/tar: tar
provided_by mail-mta/{{e,m,s}smtp,courier,exim,netqmail,nullmailer,opensmtpd,postfix,sendmail} : sendmail
provided_by net-analyzer/traceroute: traceroute
provided_by net-dialup/ppp: chat
provided_by net-dns/bind-tools: nslookup
provided_by net-misc/iputils: ping tftpd
provided_by net-misc/wget: wget
provided_by net-misc/whois: mkpasswd whois
provided_by net-print/{'cups[-lprng-compat(-)]',lprnq} : lpq lpr
provided_by sys-apps/coreutils: ${COREUTILS_USR_BIN} ${COREUTILS_USR_SBIN} dir vdir
provided_by sys-apps/diffutils: cmp diff
provided_by sys-apps/ed: ed
provided_by sys-apps/findutils: find xargs
provided_by sys-apps/grep: egrep fgrep grep
provided_by sys-apps/iproute2: ip
provided_by sys-apps/less: less
provided_by sys-apps/kbd: ${KBD_USR_BIN} setfont
provided_by sys-apps/man sys-apps/man-db: man
provided_by sys-apps/net-tools: dnsdomainname ifconfig iptunnel nameif netstat route
provided_by sys-apps/pciutils: lspci
provided_by sys-apps/sed: sed
provided_by sys-apps/shadow: chpasswd groupadd groupdel groups login passwd su useradd userdel
provided_by sys-apps/usbutils: lsusb
provided_by sys-apps/util-linux: blkid blockdev cal dmesg findfs flock fsck hexdump hwclock last linux32 linux64 losetup mkswap mount mountpoint pivot_root script setarch swapoff swapon switch_root umount
provided_by sys-apps/which: which
provided_by sys-devel/patch: patch
provided_by sys-fs/dosfstools: mkdosfs mkfs.vfat
provided_by sys-fs/e2fsprogs: chattr lsattr mke2fs mkfs.ext2 tune2fs
provided_by sys-power/acpid: acpid
provided_by sys-process/cronie: crond
provided_by sys-process/lsof: lsof
provided_by sys-process/procps: ${PROCPS_USR_BIN} ps sysctl
provided_by sys-process/psmisc: fuser killall pstree
provided_by x11-terms/xterm: resize

provided_by 'sys-apps/net-tools[arp(+)]': arp
provided_by 'sys-apps/coreutils[hostname(-)]' 'sys-apps/net-tools[hostname(+)]': hostname
provided_by 'sys-apps/coreutils[kill(-)]' 'sys-apps/util-linux[kill(-)]' 'sys-process/procps[kill(+)]': kill
provided_by 'sys-apps/more' 'sys-apps/util-linux[ncurses]': more
provided_by 'sys-apps/kmod[tools]' sys-apps/modutils: ${KMOD_SBIN}

S=${WORKDIR}

pkg_setup() {
	local _available_applets="$("${SYSROOT}"/bin/busybox --list)"
	local _missing_applets=()
	local _all_applets=( ${APPLETS_ALL} )
	for a in "${_all_applets[@]#[+-]}" ; do
		if use "$a" ; then
			has "$a" ${_available_applets} || _missing_applets+=("$a")
		fi
	done
	if [[ -n ${_missing_applets[@]} ]] ; then
		eerror "These applets are missing from the Busybox binary:"
		eerror "${_missing_applets[@]}"
		eerror "Please enable them and recompile busybox"
		die "Aborting due to missing applets"
	fi
}

src_install() {
	cat > wrapper << EOF
#!/bin/busybox
EOF
	exeinto /
	use_if_iuse linuxrc && newexe wrapper linuxrc
	into /
	use_if_iuse dir && newbin - dir << EOF
#!/bin/sh
ls --color=never -C
EOF
	use_if_iuse vdir && newbin - vdir << EOF
#!/bin/sh
ls --color=never -l
EOF
	for a in ${APPLETS_BIN} ; do
		use $a && newbin wrapper $a
	done
	for a in ${APPLETS_SBIN} ; do
		use $a && newsbin wrapper $a
	done

	into /usr
	use_if_iuse '[' && newbin wrapper test
	for a in ${APPLETS_USR_BIN} ; do
		use $a && newbin wrapper $a
	done
	for a in ${APPLETS_USR_SBIN} ; do
		use $a && newsbin wrapper $a
	done

	use_if_iuse groupadd && newsbin - groupadd << EOF
#!/bin/sh
/bin/busybox addgroup \$(while [ "\$#" -ne 0 ]
do case "\$1" in
	-r|--system) printf %s\  -S ; shift ;;
	-g|--gid) printf %s\ %s\  -g "\$2" ; shift 2 ;;
	-g*) printf %s\ %s\  -g "\${1#-g}" ; shift ;;
	--gid=*) printf %s\ %s\  -g "\${1#*=}" ; shift ;;
	-h|--help) printf %s\ --help ; shift ;;
	*) printf %s\  "\$1" ; shift ;; esac
done)
EOF
	use_if_iuse groupdel && newsbin - groupdel << EOF
EOF
	use_if_iuse useradd && newsbin - useradd << EOF
#!/bin/sh
COMMENT="Linux User"
/bin/busybox adduser -D \$(while [ "\$#" -ne 0 ]
do case "\$1" in
	-r|--system) printf %s\  -S ; shift ;;
	-m|--create-home) NOHOME_ARG= ; shift ;;
	-M|--no-create-home) NOHOME_ARG=-H ; shift ;;
	-c|--comment) COMMENT="\$2" ; shift 2 ;;
	-c*) COMMENT="\${1#-c}" ; shift ;;
	--comment=*) COMMENT="\${1#*=}" ; shift ;;
	-d|--home-dir) printf %s\ %s\  -h "\$2" ; shift 2 ;;
	-d*) printf %s\ %s\  -h "\${1#-d}" ; shift ;;
	--home-dir=*) printf %s\ %s\  -h "\${1#*=}" ; shift ;;
	-s|--shell) printf %s\ %s\  -s "\$2" ; shift 2 ;;
	-s*) printf %s\ %s\  -s "\${1#-s}" ; shift ;;
	--shell=*) printf %s\ %s\  -u "\${1#*=}" ; shift ;;
	-u|--uid) printf %s\ %s\  -u "\$2" ; shift 2 ;;
	-u*) printf %s\ %s\  -u "\${1#-u}" ; shift ;;
	--uid=*) printf %s\ %s\  -u "\${1#*=}" ; shift ;;
	--home-dir=*) printf %s\ %s\  -h "\${1#*=}" ; shift ;;
	-h|--help) printf %s\  --help ; shift ;;
	-e) echo "Sorry, no expiredate with busybox" >&2 ; exit 1 ;;
	-g) echo "Sorry, no GID with busybox" >&2 ; exit 1 ;;
	*) printf %s\  "\$1" ; shift ;; esac
done
[ -n "\$NOHOME_ARG" ] && echo "\$NOHOME_ARG") -g "$COMMENT"
EOF
	use_if_iuse userdel && newsbin - userdel << EOF
EOF
}

pkg_postinst() {
	if [[ ! -x ${ROOT}/bin/sh ]] ; then
		einfo "It appears that the /bin/sh symlink is missing from your system."
		einfo "I am too lazy to create it for you."
		einfo "You can create it yourself using the following command:"
		einfo "     eselect sh update"
	fi
}
