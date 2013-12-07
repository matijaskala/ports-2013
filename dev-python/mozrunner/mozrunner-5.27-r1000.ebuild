# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}threads]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Reliable start/stop/configuration of Mozilla Applications (Firefox, Thunderbird, etc.)"
HOMEPAGE="https://pypi.python.org/pypi/mozrunner"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend ">=dev-python/mozcrash-0.10")
	$(python_abi_depend ">=dev-python/mozdevice-0.28")
	$(python_abi_depend ">=dev-python/mozinfo-0.7")
	$(python_abi_depend ">=dev-python/mozlog-1.3")
	$(python_abi_depend ">=dev-python/mozprocess-0.13")
	$(python_abi_depend ">=dev-python/mozprofile-0.16")
	$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"

src_prepare() {
	distutils_src_prepare

	# Disable installation of Windows-specific files.
	sed -e "/package_data={'mozrunner': \[/,/\]},/d" -i setup.py
}
