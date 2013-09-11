# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit multilib-build

DESCRIPTION="Virtual to select between sys-fs/udev and sys-fs/eudev"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~*"
# These default enabled IUSE flags should follow defaults of sys-fs/udev.
IUSE="gudev introspection +kmod selinux static-libs"

DEPEND=""
RDEPEND="|| ( >=sys-fs/udev-206-r2[${MULTILIB_USEDEP},gudev?,introspection?,kmod?,selinux?,static-libs?]
	>=sys-apps/systemd-206[${MULTILIB_USEDEP},gudev?,introspection?,kmod?,selinux?,static-libs(-)?]
	kmod? ( >=sys-fs/eudev-1.2-r1[${MULTILIB_USEDEP},keymap,modutils,gudev?,hwdb,introspection?,selinux?,static-libs?] )
	!kmod? ( >=sys-fs/eudev-1.2-r1[${MULTILIB_USEDEP},keymap,gudev?,hwdb,introspection?,selinux?,static-libs?] )
	)"
