# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# 2.5: https://bitbucket.org/tarek/distribute/issue/318
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="2.5 *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Setuptools is a collection of extensions to Distutils"
HOMEPAGE="https://pythonhosted.org/setuptools/ https://bitbucket.org/pypa/setuptools https://pypi.python.org/pypi/setuptools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="README.txt docs/easy_install.txt docs/pkg_resources.txt docs/setuptools.txt"
PYTHON_MODULES="_markerlib easy_install.py pkg_resources.py setuptools"

src_prepare() {
	distutils_src_prepare

	# Disable tests requiring network connection.
	rm -f setuptools/tests/test_packageindex.py
}

src_test() {
	# test_install_site_py fails with disabled byte-compiling in Python 2.7 / >=3.2.
	python_enable_pyc

	distutils_src_test

	python_disable_pyc

	find -name "__pycache__" -print0 | xargs -0 rm -fr
	find "(" -name "*.pyc" -o -name "*\$py.class" ")" -delete
}

src_install() {
	SETUPTOOLS_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT="1" distutils_src_install
}
