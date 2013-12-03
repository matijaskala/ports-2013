# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/httpretty/httpretty-0.7.0.ebuild,v 1.2 2013/12/03 02:15:29 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="HTTP client mock for Python"
HOMEPAGE="http://github.com/gabrielfalcao/httpretty"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="test"
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/urllib3[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.5[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/nose-1.2[${PYTHON_USEDEP}]
		>=dev-python/requests-1.1[${PYTHON_USEDEP}]
		>=dev-python/steadymark-0.4.5[${PYTHON_USEDEP}]
		>=dev-python/sure-1.2.1[${PYTHON_USEDEP}]
		>=www-servers/tornado-2.2[${PYTHON_USEDEP}]
		"
# I believe we don't need unpackaged package markment
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/sure[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${P}-deps.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all
	if ! use test; then
		rm -rf tests/
	fi
}

python_test() {
	# https://github.com/gabrielfalcao/HTTPretty/issues/125
	nosetests tests/unit \
		-e test_recording_calls \
		-e test_playing_calls \
		-e test_callback_setting_headers_and_status_response \
		tests/functional || die "Tests failed under ${EPYTHON}"
	rm -rf tests/ "${BUILD_DIR}"/lib/tests/ || die
}
