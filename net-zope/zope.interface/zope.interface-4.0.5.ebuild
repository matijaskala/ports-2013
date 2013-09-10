# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

DESCRIPTION="Interfaces for Python"
HOMEPAGE="http://pypi.python.org/pypi/zope.interface"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip
	mirror://pypi/${PN:0:1}/${PN}/${PN}-3.8.0.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="*"
IUSE="doc test"

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	!<net-zope/zope-interface-1000"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? (
		$(python_abi_depend dev-python/repoze.sphinx.autointerface)
		$(python_abi_depend dev-python/sphinx)
	)
	test? ( $(python_abi_depend net-zope/zope.event) )"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
DOCS="CHANGES.rst"
PYTHON_MODULES="${PN/.//}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-4.0.1-python-3.1.patch"

	preparation() {
		if [[ "$(python_get_version -l)" == "2.5" ]]; then
			cp -fr "${WORKDIR}/${PN}-3.8.0" "${S}-${PYTHON_ABI}"
		else
			cp -fr "${WORKDIR}/${P}" "${S}-${PYTHON_ABI}"
		fi
	}
	python_execute_function preparation
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
	python_clean_installation_image

	if use doc; then
		dohtml -r docs/_build/html/
	fi
}
