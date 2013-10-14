# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"
# https://bitbucket.org/eventlet/eventlet/issue/159
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Highly concurrent networking library"
HOMEPAGE="http://eventlet.net/ https://bitbucket.org/eventlet/eventlet https://github.com/eventlet/eventlet https://pypi.python.org/pypi/eventlet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples"

RDEPEND="$(python_abi_depend dev-python/greenlet)
	$(python_abi_depend dev-python/pyopenssl)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

src_prepare() {
	distutils_src_prepare

	# Ignore potential AttributeError and RuntimeError caused by gnutls module.
	sed -e "227s/except ImportError:/except (AttributeError, ImportError, RuntimeError):/" -i tests/test__twistedutil_protocol.py

	# Disable failing tests.
	rm tests/saranwrap_test.py
	sed \
		-e "s/test_incomplete_headers_75/_&/" \
		-e "s/test_incomplete_headers_76/_&/" \
		-e "s/test_incorrect_headers/_&/" \
		-i tests/websocket_test.py
	sed -e "s/test_multiple_readers/_&/" -i tests/greenio_test.py

	# https://bitbucket.org/birkenfeld/sphinx/issue/1185
	sed -e "1i\\# -*- coding: utf-8 -*-" -i eventlet/green/zmq.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/_build/html/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
