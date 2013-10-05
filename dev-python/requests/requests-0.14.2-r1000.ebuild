# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit distutils

DESCRIPTION="Python HTTP for Humans."
HOMEPAGE="http://python-requests.org/ https://github.com/kennethreitz/requests https://pypi.python.org/pypi/requests"
# SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/kennethreitz/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="app-misc/ca-certificates
	$(python_abi_depend dev-python/chardet)
	$(python_abi_depend -i "2.*" dev-python/oauthlib)
	$(python_abi_depend dev-python/urllib3)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="HISTORY.rst README.rst"

src_unpack() {
	default
	mv kennethreitz-requests-* ${P}
}

src_prepare() {
	distutils_src_prepare

	# Use system version of dev-python/chardet.
	sed \
		-e "s/from .packages import chardet$/import chardet/" \
		-e "s/from .packages import chardet2 as chardet$/import chardet/" \
		-i requests/compat.py
	rm -fr requests/packages/chardet
	rm -fr requests/packages/chardet2

	# Delete internal copy of dev-python/oauthlib.
	rm -fr requests/packages/oauthlib

	# Use system version of dev-python/urllib3.
	sed -e "s/from . import urllib3/import urllib3/" -i requests/packages/__init__.py
	sed -e "s/\(from \).packages.\(urllib3.* import\)/\1\2/" -i requests/*.py
	rm -fr requests/packages/urllib3

	# Disable installation of deleted internal copies of dev-python/chardet, dev-python/oauthlib and dev-python/urllib3.
	sed \
		-e "/requests.packages.urllib3/d" \
		-e "/if is_py2:/,/^$/d" \
		-i setup.py

	# https://github.com/kennethreitz/requests/issues/882
	sed -e 's/\(if \|(\)callable(\([^)]*\))/\1hasattr(\2, "__call__")/' -i requests/models.py tests/test_requests.py
}

src_test() {
	testing() {
		local exit_status="0" test
		for test in tests/test_*.py; do
			python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" "${test}" -v || exit_status="1"
		done

		return "${exit_status}"
	}
	python_execute_function testing
}
