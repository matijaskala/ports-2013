# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-2

DESCRIPTION="Tools for mounting /usr without initramfs"
HOMEPAGE=""
GITHUB_USER="matijaskala"
EGIT_REPO_URI="https://www.github.com/${GITHUB_USER}/${PN}.git"

SLOT="0"
KEYWORDS="*"
IUSE="+bindist"
DEPEND="!bindist? ( sys-apps/busybox:=[static] )"

src_compile() {
	emake
}

src_install() {
	dodir /etc
	emake install DESTDIR=/etc
	if ! use bindist; then
		rm ${D}/etc/bin/busybox || die
		[[ -x /bin/busybox ]] && cp /bin/busybox ${D}/etc/bin/busybox || die "/bin/busybox is not executable"
	fi
	[[ -x ${D}/etc/init ]] || chmod +x ${D}/etc/init
}
