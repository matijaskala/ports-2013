# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Funtoo's configuration tool: ego, epro, edoc."
HOMEPAGE="http://www.funtoo.org/Package:Ego"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"
GITHUB_REPO="$PN"
GITHUB_USER="funtoo"
GITHUB_TAG="${PV}"
SRC_URI="https://www.github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/${GITHUB_TAG} -> ${PN}-${GITHUB_TAG}.tar.gz"

DEPEND=""
RDEPEND="=dev-lang/python-3*
	dev-python/requests"

PATCHES=( "${FILESDIR}"/profile.ego.patch )

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${GITHUB_USER}-${PN}"-??????? "${S}" || die
}

src_install() {
	exeinto /usr/share/ego/modules
	doexe modules/profile.ego
	insinto /usr/share/ego/modules-info
	doins modules-info/profile.json
	insinto /usr/share/ego/python
	doins -r python/*
	rm -rf ${D}/usr/share/ego/python/test
	dobin ego
	dosym ego /usr/bin/epro
	doman doc/ego{.1,-profile.8}
}
