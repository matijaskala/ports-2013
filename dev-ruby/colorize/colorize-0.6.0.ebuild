# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/colorize/colorize-0.6.0.ebuild,v 1.1 2013/09/26 05:26:23 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Add some methods to set color, background color and text effect on console easier"
HOMEPAGE="https://github.com/fazibear/colorize http://colorize.rubyforge.org"
LICENSE="GPL-2+"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

each_ruby_test() {
	cd test || die
	${RUBY} test_colorize.rb || die
}
