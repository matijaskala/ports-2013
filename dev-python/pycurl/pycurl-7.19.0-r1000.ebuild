# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit distutils eutils

DESCRIPTION="Python binding for curl/libcurl"
HOMEPAGE="http://pycurl.sourceforge.net/ https://pypi.python.org/pypi/pycurl"
SRC_URI="http://pycurl.sourceforge.net/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="curl_ssl_gnutls curl_ssl_nss +curl_ssl_openssl examples ssl"

DEPEND=">=net-misc/curl-7.25.0-r1[ssl=]
	ssl? ( net-misc/curl[curl_ssl_gnutls=,curl_ssl_nss=,curl_ssl_openssl=,-curl_ssl_axtls,-curl_ssl_cyassl,-curl_ssl_polarssl] )"
RDEPEND="${DEPEND}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

PYTHON_MODULES="curl"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-linking.patch"
	epatch "${FILESDIR}/${P}-python3.patch"

	sed -e "/data_files=/d" -i setup.py || die "sed failed"
}

src_test() {
	testing() {
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" tests/test_internals.py -q
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	dohtml -r doc/*

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples tests
	fi
}
