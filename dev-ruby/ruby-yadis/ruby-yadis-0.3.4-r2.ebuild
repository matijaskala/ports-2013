# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-yadis/ruby-yadis-0.3.4-r2.ebuild,v 1.1 2013/10/30 04:23:04 mrueg Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="A ruby library for performing Yadis service discovery"
HOMEPAGE="http://yadis.rubyforge.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

each_ruby_prepare() {
	# Remove live tests that require content that is no longer available.
	rm test/test_discovery.rb || die
	sed -i -e '/test_discovery/d' test/runtests.rb || die
}

each_ruby_test() {
	${RUBY} -I../lib:lib:test -Ctest runtests.rb || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r examples
}
