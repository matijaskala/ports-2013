# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/actionpack/actionpack-4.0.2.ebuild,v 1.1 2013/12/04 19:23:51 graaff Exp $

EAPI=5

USE_RUBY="ruby19"

# The default test task tries to test activerecord with SQLite as well.
RUBY_FAKEGEM_TASK_TEST="test_action_pack"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="actionpack.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Eases web-request routing, handling, and response."
HOMEPAGE="http://rubyforge.org/projects/actionpack/"
SRC_URI="http://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/builder-3.1.0:3.1
	>=dev-ruby/rack-1.5.2:1.5
	>=dev-ruby/rack-test-0.6.2:0.6
	>=dev-ruby/sprockets-2.2.1:2.2
	>=dev-ruby/erubis-2.7.0"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.13
		dev-ruby/bundler
		~dev-ruby/activemodel-${PV}
		~dev-ruby/activerecord-${PV}
		~dev-ruby/actionmailer-${PV}
		dev-ruby/sprockets-rails:2.0
		>=dev-ruby/tzinfo-0.3.29:0
		>=dev-ruby/uglifier-1.0.3
	)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|jquery-rails\|'mysql'\|journey\|ruby-prof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|sprockets-rails\)/d" ../Gemfile || die

	sed -i -e '/rack-ssl/d' -e 's/~> 3.4/>= 3.4/' ../railties/railties.gemspec || die
	sed -i -e '/mail/d' ../actionmailer/actionmailer.gemspec || die

	sed -i -e '/bcrypt/ s/3.0.0/3.0/' ../Gemfile || die

	# Add back json in the Gemfile because we dropped some dependencies
	# earlier that implicitly required it.
	sed -i -e '$agem "json"' ../Gemfile || die

	# Avoid fragile tests depending on hash ordering
	sed -i -e '/cookie_3=chocolate/ s:^:#:' test/controller/integration_test.rb || die
	sed -i -e '/test_to_s/,/end/ s:^:#:' test/template/html-scanner/tag_node_test.rb || die
	sed -i -e '/"name":"david"/ s:^:#:' test/controller/mime_responds_test.rb || die
	sed -i -e '/test_option_html_attributes_with_multiple_element_hash/, / end/ s:^:#:' test/template/form_options_helper_test.rb || die
	sed -i -e '/test_option_html_attributes_with_multiple_hashes/, / end/ s:^:#:' test/template/form_options_helper_test.rb || die

	# Avoid fragile test that gets more output than it expects.
	sed -i -e '/test_locals_option_to_assert_template_is_not_supported/,/end/ s:^:#:'  test/controller/render_test.rb || die
}
