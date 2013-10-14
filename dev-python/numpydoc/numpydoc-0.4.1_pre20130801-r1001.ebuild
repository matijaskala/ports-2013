# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils vcs-snapshot

DESCRIPTION="Sphinx extension to support docstrings in Numpy format"
HOMEPAGE="https://github.com/numpy/numpydoc https://pypi.python.org/pypi/numpydoc"
SRC_URI="https://github.com/numpy/${PN}/archive/447dd0b59c2fe91ca9643701036d3d04919ddc7e.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BSD-2 matplotlib"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/sphinx)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

src_prepare() {
	distutils_src_prepare

	# Fix compatibility with Python 3.1 and 3.2.
	sed -e "s/ or (3, 0) <= sys.version_info\[0:2\] < (3, 3)//" -i setup.py
	sed -e "s/callable(\([^)]\+\))/(hasattr(\1, '__call__') if __import__('sys').version_info\[:2\] == (3, 1) else &)/" -i numpydoc/docscrape_sphinx.py

	# Delete deprecated module.
	rm -f numpydoc/plot_directive.py numpydoc/tests/test_plot_directive.py

	# https://github.com/numpy/numpydoc/pull/1
	sed -e "s/doc = str(doc).decode('utf-8')/doc = unicode(doc)/" -i numpydoc/numpydoc.py
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/numpydoc/tests"
	}
	python_execute_function -q delete_tests
}
