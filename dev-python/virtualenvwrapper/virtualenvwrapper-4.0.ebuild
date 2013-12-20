# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/virtualenvwrapper/virtualenvwrapper-4.0.ebuild,v 1.1 2013/05/02 06:09:52 patrick Exp $

EAPI=4

PYTHON_DEPEND="2:2.6 3:3.1"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 *-jython 2.7-pypy-*"

inherit distutils python

DESCRIPTION="virtualenvwrapper is a set of extensions to Ian Bicking's virtualenv tool"
HOMEPAGE="http://www.doughellmann.com/projects/virtualenvwrapper http://pypi.python.org/pypi/virtualenvwrapper"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT=test

RDEPEND="dev-python/virtualenv
	dev-python/stevedore
	dev-python/virtualenv-clone"
DEPEND="${DEPEND}
	dev-python/setuptools
	test? ( dev-python/tox )"

src_prepare() {
	sed -e 's:-o shwordsplit::' -i tests/run_tests || die
}

src_test() {
	testing() {
		PYTHON_MAJOR="$(python_get_version --major)"
		PYTHON_MINOR="$(python_get_version --minor)"
		cp "${FILESDIR}/tox.ini" .
		export TMPDIR=${T}
		tox -e py${PYTHON_MAJOR}${PYTHON_MINOR} tests/test_cp.sh
	}
	python_execute_function testing
}
