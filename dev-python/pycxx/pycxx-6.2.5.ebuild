# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycxx/pycxx-6.2.5.ebuild,v 1.1 2013/08/28 00:01:20 floppym Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} pypy2_0 )

inherit eutils distutils-r1

DESCRIPTION="Set of facilities to extend Python with C++"
HOMEPAGE="http://cxx.sourceforge.net"
SRC_URI="mirror://sourceforge/cxx/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="doc examples"

python_prepare_all() {
	# Without this, pysvn fails.
	# CXX/Python2/Config.hxx: No such file or directory
	sed -e "/^#include/s:/Python[23]/:/:" -i CXX/*/*.hxx || die "sed failed"

	# Remove python2 print statement
	echo > Lib/__init__.py || die

	local PATCHES=(
		"${FILESDIR}/${PN}-6.2.3-installation.patch"
	)
	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && local HTML_DOCS=( Doc/ )
	use examples && local EXAMPLES=( Demo/Python{2,3}/ )
	distutils-r1_python_install_all
}
