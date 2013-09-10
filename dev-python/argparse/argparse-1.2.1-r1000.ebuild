# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="2.7 3.[2-9]"

inherit distutils

DESCRIPTION="Python command-line parsing library"
HOMEPAGE="http://code.google.com/p/argparse/ http://pypi.python.org/pypi/argparse"
SRC_URI="http://argparse.googlecode.com/files/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

PYTHON_MODULES="argparse.py"

src_test() {
	testing() {
		python_execute COLUMNS="80" PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_argparse.py
	}
	python_execute_function testing
}
