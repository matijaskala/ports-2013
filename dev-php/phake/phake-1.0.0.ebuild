# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

DESCRIPTION="A rake/make clone for PHP 5.3"
HOMEPAGE="https://github.com/jaz303/phake"
EGIT_REPO_URI="git://github.com/jaz303/phake.git"
LICENSE="MIT"
SLOT="0"
IUSE="bash-completion"

DEPEND="dev-lang/php"
RDEPEND="${DEPEND}"

src_compile() {
	php build.php
}

src_install() {
	if use bash-completion; then
		insinto /etc/bash_completion.d
		doins phake_completion.sh
	fi
	dobin phake
}
