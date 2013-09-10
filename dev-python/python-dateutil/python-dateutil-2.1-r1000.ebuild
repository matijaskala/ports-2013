# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"

inherit distutils

DESCRIPTION="Extensions to the standard Python datetime module"
HOMEPAGE="https://launchpad.net/dateutil http://pypi.python.org/pypi/python-dateutil"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples"

RDEPEND="$(python_abi_depend dev-python/six)
	sys-libs/timezone-data
	!<dev-python/python-dateutil-2.1"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="NEWS README"
PYTHON_MODULES="dateutil"

src_prepare() {
	distutils_src_prepare

	# Use zoneinfo in /usr/share/zoneinfo.
	sed -e "s/zoneinfo.gettz/gettz/g" -i test.py || die "sed failed"

	# Fix parsing of date in non-English locales.
	sed -e 's/subprocess.getoutput("date")/subprocess.getoutput("LC_ALL=C date")/' -i example.py
}

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_zoneinfo() {
		rm -f "${ED}$(python_get_sitedir)/dateutil/zoneinfo/"*.tar.*
	}
	python_execute_function -q delete_zoneinfo

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins example.py sandbox/*.py
	fi
}
