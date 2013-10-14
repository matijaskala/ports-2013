# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"
# https://github.com/networkx/networkx/issues/975
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.[3-9]"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Python package for creating and manipulating graphs and networks"
HOMEPAGE="http://networkx.lanl.gov/ https://networkx.github.io/ https://github.com/networkx/networkx https://pypi.python.org/pypi/networkx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples graphviz matplotlib numpy pyparsing scipy yaml"
REQUIRED_USE="examples? ( graphviz matplotlib numpy pyparsing scipy )"

RDEPEND="$(python_abi_depend dev-python/decorator)
	graphviz? ( $(python_abi_depend -e "3.*" dev-python/pygraphviz) )
	matplotlib? ( $(python_abi_depend -e "*-pypy-*" dev-python/matplotlib) )
	numpy? ( $(python_abi_depend -e "*-pypy-*" dev-python/numpy) )
	pyparsing? ( $(python_abi_depend dev-python/pyparsing) )
	scipy? ( $(python_abi_depend -e "*-pypy-*" sci-libs/scipy) )
	yaml? ( $(python_abi_depend dev-python/pyyaml) )"
DEPEND="${RDEPEND}
	doc? (
		dev-python/matplotlib[python_abis_2.7]
		dev-python/sphinx[python_abis_2.7]
	)"

src_prepare() {
	distutils_src_prepare

	# Do not use internal copy of dev-python/decorator.
	rm -r networkx/external/decorator/{decorator2,decorator3}
	echo "from decorator import *" > networkx/external/decorator/__init__.py
	sed -e "s/packages.append('networkx.external.decorator.decorator.')/pass/" -i setup.py

	# Disable installation of INSTALL.txt and LICENSE.txt.
	sed -e 's/data = \[(docdirbase, glob("\*.txt"))\]/data = [(docdirbase, [x for x in glob("*.txt") if x not in ("INSTALL.txt", "LICENSE.txt")])]/' -i setup.py

	# Fix compatibility with Python 3.1.
	# https://github.com/networkx/networkx/issues/974
	sed -e "s/s=tostring(self.xml).decode(self.encoding)/s=(tostring(self.xml) if __import__('sys').version_info[:2] == (3, 1) else tostring(self.xml).decode(self.encoding))/" -i networkx/readwrite/gexf.py networkx/readwrite/graphml.py

	python_convert_shebangs 2.7 doc/{make_examples_rst.py,make_gallery.py}
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		PYTHONPATH=".." emake html SPHINXBUILD="sphinx-build-2.7"
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -r "${ED}$(python_get_sitedir)/networkx/"**/tests
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r doc/build/html/
	fi

	if ! use examples; then
		rm -r "${ED}usr/share/doc/${PF}/examples"
	fi
}
