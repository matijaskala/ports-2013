# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/chunky_png/chunky_png-1.3.1.ebuild,v 1.1 2014/04/29 05:25:02 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 jruby"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""

RUBY_FAKEGEM_EXTRADOC="BENCHMARKS.rdoc README.rdoc"

RUBY_FAKEGEM_GEMSPEC="chunky_png.gemspec"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby library that can read and write PNG images"
HOMEPAGE="http://wiki.github.com/wvanbergen/chunky_png"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/[bB]undler/s:^:#:' {spec,benchmarks}/*.rb || die
	rm Gemfile* || die

	# Avoid git dependency
	sed -i -e '/s.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}
