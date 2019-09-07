# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU network utilities"
HOMEPAGE="https://www.gnu.org/software/inetutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-linux"
IUSE="+dnsdomainname +ftp +hostname +ifconfig +logger +ping +ping6 +rsh +telnet +traceroute +tftp +whois"

DEPEND="ftp? ( sys-libs/readline )"
RDEPEND="${DEPEND}
	dnsdomainname? ( !sys-apps/net-tools )
	ftp? ( !net-ftp/ftp )
	hostname? (
		!sys-apps/coreutils[hostname]
		!sys-apps/net-tools[hostname]
	)
	ifconfig? ( !sys-apps/net-tools )
	logger? ( !sys-apps/util-linux )
	ping? ( !net-misc/iputils )
	ping6? ( !net-misc/iputils[ipv6] )
	rsh? ( !net-misc/netkit-rsh )
	telnet? ( !net-misc/netkit-telnetd )
	telnet? ( !net-misc/telnet-bsd )
	traceroute? ( !net-analyzer/traceroute )
	tftp? ( !net-ftp/tftp-hpa )
	whois? ( !net-misc/whois )"

src_configure() {
	local myconf=(
		$(use_enable dnsdomainname)
		$(use_enable ftp)
		$(use_enable hostname)
		$(use_enable ifconfig)
		$(use_enable logger)
		$(use_enable ping)
		$(use_enable ping6)
		$(use_enable rsh rcp)
		$(use_enable rsh rexec)
		$(use_enable rsh rlogin)
		$(use_enable rsh)
		$(use_enable telnet)
		$(use_enable tftp)
		$(use_enable traceroute)
		$(use_enable whois)
		--disable-talk
	)

	econf "${myconf[@]}"
}
