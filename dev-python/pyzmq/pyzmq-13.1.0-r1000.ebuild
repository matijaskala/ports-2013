# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython *-pypy-*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Python bindings for ZeroMQ"
HOMEPAGE="http://www.zeromq.org/bindings:python https://github.com/zeromq/pyzmq https://pypi.python.org/pypi/pyzmq"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

# Main licenses: BSD LGPL-3
# zmq/eventloop: Apache-2.0
# zmq/ssh/forward.py: LGPL-2.1
LICENSE="Apache-2.0 BSD LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="examples tornado"

DEPEND=">=net-libs/zeromq-2.2.0
	tornado? ( $(python_abi_depend -e "3.1" www-servers/tornado) )"
RDEPEND="${DEPEND}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="README.md"
PYTHON_MODULES="zmq"

src_test() {
	python_execute_nosetests -e -P '$(ls -d build-${PYTHON_ABI}/lib.*)' -- -s -w '$(ls -d build-${PYTHON_ABI}/lib.*/zmq/tests)'
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/zmq/tests/"test_*.py
	}
	python_execute_function -q delete_tests

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
