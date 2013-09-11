# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Tools for mounting /usr without initramfs"
HOMEPAGE=""
GITHUB_USER="matijaskala"
SRC_URI="https://www.github.com/${GITHUB_USER}/${PN}/tarball/master -> ${PN}.tar.gz"

SLOT="0"
KEYWORDS="*"
IUSE=""

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${GITHUB_USER}-${PN}"-??????? "${S}"
}

src_install() {
	dodir /etc
	cp -pPR ${S}/* ${D}/etc/ || die
}
