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

src_install() {
	newins - /etc/calamares/settings.conf <<- EOF
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
	newins - /etc/calamares/modules/locale.conf <<- EOF
		---
		geoipUrl: "geoip.ubuntu.com/lookup"
		geoipStyle: "xml"
		EOF
	newins - /etc/calamares/modules/unpackfs.conf <<- EOF
		---
		unpack:
		    -   source: /mnt/cdrom/image.squashfs
		        sourcefs: squashfs
		        destication: ""
		EOF
}
