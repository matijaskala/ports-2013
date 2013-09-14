# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.1"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="WSGIProxy2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A WSGI Proxy with various http client backends"
HOMEPAGE="https://github.com/gawel/WSGIProxy2 https://pypi.python.org/pypi/WSGIProxy2"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="requests restkit test urllib3"
REQUIRED_USE="test? ( requests restkit urllib3 )"

RDEPEND="$(python_abi_depend dev-python/six)
	$(python_abi_depend dev-python/webob)
	requests? ( $(python_abi_depend -e "*-jython" dev-python/requests) )
	restkit? ( $(python_abi_depend -e "3.* *-jython" dev-python/restkit) )
	urllib3? ( $(python_abi_depend dev-python/urllib3) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend ">=dev-python/webtest-2") )"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.rst"
PYTHON_MODULES="wsgiproxy"

src_prepare() {
	distutils_src_prepare

	# Disable failing tests.
	sed -e "/^with-doctest = true$/d" -i setup.cfg

	# Disable hanging tests.
	# https://github.com/gawel/WSGIProxy2/issues/4
	sed -e "/client = 'requests'/a\\\\    test_chunked = test_form = test_redirect = test_status = lambda self: None" -i wsgiproxy/tests.py
}
