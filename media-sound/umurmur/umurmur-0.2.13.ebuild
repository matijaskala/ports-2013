# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/umurmur/umurmur-0.2.13.ebuild,v 1.3 2013/10/26 22:04:02 pacho Exp $

EAPI=5

inherit eutils readme.gentoo user

DESCRIPTION="Minimalistic Murmur (Mumble server)"
HOMEPAGE="http://code.google.com/p/umurmur/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="polarssl"

DEPEND=">=dev-libs/protobuf-c-0.14
	dev-libs/libconfig
	polarssl? ( >=net-libs/polarssl-1.0.0 )
	!polarssl? ( dev-libs/openssl )"

RDEPEND="${DEPEND}"

DOC_CONTENTS="
	A configuration file has been installed at /etc/umurmur.conf - you may
	want to review it. See also\n
	http://code.google.com/p/umurmur/wiki/Configuring02x
"

pkg_setup() {
	enewgroup murmur
	enewuser murmur "" "" "" murmur
}

src_configure() {
	local myconf

	# build uses polarssl by default, but instead, make it use openssl
	# unless polarssl is desired.
	use !polarssl && myconf="${myconf} --with-ssl=openssl"

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/umurmurd.initd umurmurd
	newconfd "${FILESDIR}"/umurmurd.confd umurmurd

	dodoc AUTHORS ChangeLog
	newdoc README.md README

	# Some permissions are adjusted as the config may contain a server
	# password, and /etc/umurmur will typically contain the cert and the
	# key used to sign it, which are read after priveleges are dropped.
	local confdir="/etc/umurmur"
	dodir ${confdir}
	fperms 0750 ${confdir}
	fowners root:murmur ${confdir}

	insinto ${confdir}
	doins "${FILESDIR}"/umurmur.conf
	fperms 0640 ${confdir}/umurmur.conf

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if use polarssl ; then
		elog
		elog "Because you have enabled PolarSSL support, umurmurd will use a"
		elog "predefined test-certificate and key if none are configured, which"
		elog "is insecure. See http://code.google.com/p/umurmur/wiki/Installing02x#Installing_uMurmur_with_PolarSSL_support"
		elog "for more information on how to create your certificate and key"
	fi
}
