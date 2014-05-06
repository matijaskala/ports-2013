# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/builder/builder-2.1.2-r4.ebuild,v 1.1 2014/05/04 12:35:18 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 jruby"

RUBY_FAKEGEM_TASK_TEST="test_all"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README CHANGES"

inherit ruby-fakegem eutils

DESCRIPTION="A builder to facilitate programatic generation of XML markup"
HOMEPAGE="http://rubyforge.org/projects/builder/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_PATCHES=( "${FILESDIR}"/${P}-activesupport.patch "${FILESDIR}"/${P}-fix-tests.patch )

all_ruby_prepare() {
	sed -i -e '/rdoc\.template .*jamis/d' Rakefile || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby19|*ruby20|*ruby21)
			rm test/testblankslate.rb || die
			;;
		*)
			;;
	esac
}

each_ruby_test() {
	${RUBY} -Ilib:. -S testrb test/test*.rb || die
}
