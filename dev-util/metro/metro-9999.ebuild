# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2


DESCRIPTION="release metatool used for creating Gentoo and Funtoo releases"
HOMEPAGE="http://www.github.com/funtoo/metro"
EGIT_REPO_URI="git://github.com/funtoo/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+ccache +git"

DEPEND=""
RDEPEND="dev-lang/python
	ccache? ( dev-util/ccache )
	git? ( dev-vcs/git )"

src_install() {
	insinto /usr/lib/metro
	doins -r .
	fperms 0755 /usr/lib/metro/metro
	dosym /usr/lib/metro/metro /usr/bin/metro
}
