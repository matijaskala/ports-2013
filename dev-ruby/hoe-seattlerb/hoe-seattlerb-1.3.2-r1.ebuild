# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/hoe-seattlerb/hoe-seattlerb-1.3.2-r1.ebuild,v 1.2 2013/11/09 16:01:40 jer Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20 jruby"

# no tests present
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem

DESCRIPTION="Hoe plugins providing tasks used by seattle.rb"
HOMEPAGE="http://seattlerb.rubyforge.org/hoe-seattlerb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "doc? ( >=dev-ruby/hoe-2.12 )"

all_ruby_prepare() {
	# Not a real fix, but otherwise USE="doc" breaks and defaulte license is MIT
	sed -i -e "/license/d" Rakefile || die
}
