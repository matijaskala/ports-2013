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
		  - removeuser
		  - users
		  - displaymanager
		  - networkcfg
		  - hwclock
		  - bootloader
		  - packages
		  - umount
		- show:
		  - finished
		branding: slontoo
		prompt-install: true
		EOF
	insinto /etc/calamares/branding/slontoo
	newins - branding.desc <<- EOF
		---
		componentName:  slontoo
		welcomeStyleCalamares:   true
		strings:
		    productName:         Slontoo Linux
		    shortproductName:    Slontoo
		    version:             18.7
		    shortversion:        18.7
		    versionedName:       Slontoo Linux 18.7
		    shortVersionedName:  Slontoo 18.7
		    bootloaderEntryName: Slontoo
		    productUrl:          https://slontoo.sourceforge.io
		    supportUrl:          https://sourceforge.net/p/slontoo/tickets
		    knownIssuesUrl:      https://sourceforge.net/p/slontoo/tickets
		    releaseNotesUrl:     https://sourceforge.net/p/slontoo
		images:
		    productLogo:         "logo.png"
		    productIcon:         "logo.png"
		    productWelcome:      "languages.png"
		slideshow:               "show.qml"
		style:
		   sidebarBackground:    "#4c4c4c"
		   sidebarText:          "#f6f6f6"
		   sidebarTextSelect:    "#f6f6f6"
		   sidebarTextHighlight: "#1692d0"
		EOF
	newins - show.qml <<- EOF
		import QtQuick 2.0;
		import calamares.slideshow 1.0;
		
		Presentation
		{
		    id: presentation
		}
		EOF
	doins "${FILESDIR}"/languages.png
	doins "${FILESDIR}"/logo.png
	insinto /etc/calamares/modules
	newins - finished.conf <<- EOF
		---
		restartNowEnabled: true
		restartNowChecked: false
		EOF
	newins - locale.conf <<- EOF
		---
		geoipUrl: "geoip.ubuntu.com/lookup"
		geoipStyle: "xml"
		EOF
	newins - machineid.conf <<- EOF
		---
		systemd: false
		dbus: true
		symlink: true
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
		        destination: ""
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
	newins - welcome.conf <<- EOF
		---
		requirements:
		    requiredStorage:    6.0
		    requiredRam:        1.0
		    internetCheckUrl:   http://github.com
		    check:
		        - storage
		        - ram
		        - power
		        - internet
		        - root
		        - screen
		    required:
		        - storage
		        - ram
		        - internet
		        - root
		EOF
}
