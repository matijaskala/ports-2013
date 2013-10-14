# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}ssl]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="A standard Python library that abstracts away differences among multiple cloud provider APIs"
HOMEPAGE="http://libcloud.apache.org/ https://pypi.python.org/pypi/apache-libcloud"
SRC_URI="mirror://apache/${PN}/apache-${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="examples ssh test"

RDEPEND="$(python_abi_depend dev-python/lockfile)
	ssh? ( $(python_abi_depend -i "2.*-cpython" dev-python/paramiko) )"
DEPEND="${RDEPEND}
	test? (
		$(python_abi_depend dev-python/mock)
		$(python_abi_depend -i "2.6" dev-python/unittest2)
	)"

S="${WORKDIR}/apache-${P}"

src_prepare() {
	distutils_src_prepare
	cp libcloud/test/secrets.py-dist libcloud/test/secrets.py || die "cp failed"
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/libcloud/test"
	}
	python_execute_function -q delete_tests

	if use examples; then
		docinto examples
		dodoc example_*.py
	fi
}
