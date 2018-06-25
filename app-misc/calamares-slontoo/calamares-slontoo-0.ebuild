# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Configuration files for Calamares installer"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-admin/calamares"

S=${WORKDIR}

src_install() {
	insinto /etc/calamares
	newins - settings.conf <<- EOF
		---
		modules-search: [ local ]
		sequence:
		- show:
		  - welcome
		  - locale
		  - keyboard
		  - partition
		  - users
		  - summary
		- exec:
		  - partition
		  - mount
		  - unpackfs
		  - machineid
		  - fstab
		  - locale
		  - keyboard
		  - localecfg
		  - users
		  - displaymanager
		  - networkcfg
		  - hwclock
		  - bootloader
		  - umount
		- show:
		  - finished
		branding: default
		prompt-install: true
		EOF
	insinto /etc/calamares/modules
	newins - locale.conf <<- EOF
		---
		geoipUrl: "geoip.ubuntu.com/lookup"
		geoipStyle: "xml"
		EOF
	newins - packages.conf <<- EOF
		---
		backend: portage
		skip_if_no_internet: false
		update_db: true
		operations:
		  - remove:
		    - app-admin/calamares
		    - app-misc/calamares-slontoo
		EOF
	newins - removeuser.conf <<- EOF
		---
		username: liveuser
		EOF
	newins - unpackfs.conf <<- EOF
		---
		unpack:
		    -   source: /mnt/cdrom/image.squashfs
		        sourcefs: squashfs
		        destication: ""
		EOF
	newins - users.conf <<- EOF
		---
		defaultGroups:
		    - adm
		    - audio
		    - cdrom
		    - floppy
		    - lpadmin
		    - plugdev
		    - sudo
		    - tape
		    - users
		    - video
		    - wheel
		doAutoLogin: false
		setRootPassword: false
		EOF
}
