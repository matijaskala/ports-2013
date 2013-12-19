# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/sdoc/sdoc-0.3.20.ebuild,v 1.1 2013/12/15 16:30:25 zerochaos Exp $

EAPI=5
USE_RUBY="ruby19"

inherit multilib ruby-fakegem

DESCRIPTION="rdoc generator html with javascript search index"
HOMEPAGE="https://rubygems.org/gems/sdoc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend ">=dev-ruby/json-1.1.3
	>=dev-ruby/rdoc-3.10"
