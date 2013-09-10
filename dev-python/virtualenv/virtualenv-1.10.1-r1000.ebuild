# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="http://www.virtualenv.org/ https://github.com/pypa/virtualenv https://pypi.python.org/pypi/virtualenv"
SRC_URI="https://github.com/pypa/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND="$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )
	test? ( $(python_abi_depend dev-python/mock) )"

DOCS="docs/index.rst docs/news.rst"
PYTHON_MODULES="virtualenv.py virtualenv_support"

src_prepare() {
	distutils_src_prepare

	# Disable versioning of virtualenv script to avoid collision with versioning performed by python_merge_intermediate_installation_images().
	sed -e "/'virtualenv-%s.%s=virtualenv:main' % sys.version_info\[:2\]/d" -i setup.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/_build/html/
	fi
}
