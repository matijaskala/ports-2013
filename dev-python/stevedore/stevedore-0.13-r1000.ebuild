# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Manage dynamic plugins for Python applications"
HOMEPAGE="https://github.com/dreamhost/stevedore https://pypi.python.org/pypi/stevedore"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc test"

RDEPEND="$(python_abi_depend dev-python/setuptools)
	$(python_abi_depend virtual/python-argparse)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/pbr)
	doc? ( $(python_abi_depend dev-python/sphinx) )
	test? ( $(python_abi_depend dev-python/mock) )"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		python_execute PYTHONPATH="build-$(PYTHON -f --ABI)/lib" sphinx-build docs/source html || die "Generation of documentation failed"
	fi
}

src_test() {
	python_execute_nosetests -P .
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/stevedore/tests"
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r html/
	fi
}
