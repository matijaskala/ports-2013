# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Python Git Library"
HOMEPAGE="http://www.samba.org/~jelmer/dulwich/ https://pypi.python.org/pypi/dulwich"
SRC_URI="http://www.samba.org/~jelmer/dulwich/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend -e "2.7" dev-python/unittest2) )"
RDEPEND=""

distutils_src_test_pre_hook() {
	local module
	for module in _diff_tree _objects _pack; do
		ln -fs "../$(ls -d build-${PYTHON_ABI}/lib.*)/dulwich/${module}$(python_get_extension_module_suffix)" "dulwich/${module}$(python_get_extension_module_suffix)" || die "Symlinking dulwich/${module}$(python_get_extension_module_suffix) failed with $(python_get_implementation_and_version)"
	done
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/dulwich/tests"
	}
	python_execute_function -q delete_tests
}
