# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="Rake tasks to allow easy packaging ruby projects in git"
HOMEPAGE="https://github.com/openSUSE/packaging_tasks"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/rake
"
