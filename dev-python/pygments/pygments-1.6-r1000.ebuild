# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# 3.3, 3.4: https://bitbucket.org/birkenfeld/pygments-main/issue/847
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.3 3.4 *-jython"

inherit distutils

MY_PN="Pygments"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pygments is a syntax highlighting package written in Python."
HOMEPAGE="http://pygments.org/ https://bitbucket.org/birkenfeld/pygments-main http://pypi.python.org/pypi/Pygments"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc test"

RDEPEND="$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}
	test? (
		$(python_abi_depend dev-python/nose)
		virtual/ttf-fonts
	)"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS CHANGES"

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/run.py
	}
	python_execute_function testing
}

src_install(){
	distutils_src_install

	if use doc; then
		dohtml -r docs/build/
	fi
}
