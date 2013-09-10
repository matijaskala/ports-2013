# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"

inherit distutils eutils

DESCRIPTION="Simple config file reader and writer"
HOMEPAGE="http://www.voidspace.org.uk/python/configobj.html http://code.google.com/p/configobj/ https://pypi.python.org/pypi/configobj"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

DEPEND=""
RDEPEND=""

PYTHON_MODULES="configobj.py validate.py"

src_prepare() {
	epatch "${FILESDIR}/${PN}-4.7.2-fix_tests.patch"
	sed -e "s/ \(doctest\.testmod(.*\)/ sys.exit(\1[0] != 0)/" -i validate.py
}

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" validate.py -v
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc; then
		rm -f docs/BSD*
		insinto /usr/share/doc/${PF}/html
		doins -r docs/*
	fi
}
