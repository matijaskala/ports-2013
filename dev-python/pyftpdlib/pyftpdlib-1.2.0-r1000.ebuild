# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}ssl?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"

inherit distutils

DESCRIPTION="Python FTP server library"
HOMEPAGE="http://code.google.com/p/pyftpdlib/ https://pypi.python.org/pypi/pyftpdlib"
SRC_URI="http://pyftpdlib.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="examples ssl"

# Python >=3.3 provides os.sendfile().
RDEPEND="$(python_abi_depend -e "3.[3-9] *-jython" dev-python/pysendfile)
	ssl? ( $(python_abi_depend -e "*-jython" dev-python/pyopenssl) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CREDITS HISTORY"

src_prepare() {
	distutils_src_prepare

	# http://code.google.com/p/pyftpdlib/issues/detail?id=256
	sed \
		-e "/unicode = str/i\\    basestring = str" \
		-e "/unicode = unicode/i\\    basestring = basestring" \
		-i pyftpdlib/_compat.py
	sed -e "s/from pyftpdlib._compat import PY3, u, b, getcwdu, callable/from pyftpdlib._compat import PY3, u, b, getcwdu, callable, basestring/" -i test/test_ftpd.py
}

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_contrib.py || return
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_ftpd.py || return
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r demo test
	fi
}
