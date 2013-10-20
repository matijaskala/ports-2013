# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Python Cryptography Toolkit"
HOMEPAGE="https://www.dlitz.net/software/pycrypto/ https://github.com/dlitz/pycrypto https://pypi.python.org/pypi/pycrypto"
SRC_URI="http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/${P}.tar.gz"

LICENSE="PSF-2 public-domain"
SLOT="0"
KEYWORDS="*"
IUSE="doc +gmp"

RDEPEND="gmp? ( dev-libs/gmp:0= )"
DEPEND="${RDEPEND}
	doc? (
		dev-python/docutils
		>=dev-python/epydoc-3
	)"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="ACKS ChangeLog README TODO"
PYTHON_MODULES="Crypto"

src_prepare() {
	distutils_src_prepare

	if ! use gmp; then
		# https://bugs.launchpad.net/pycrypto/+bug/1004781
		sed -e "s/test_negative_number_roundtrip_mpzToLongObj_longObjToMPZ/_&/" -i lib/Crypto/SelfTest/Util/test_number.py
	fi
}

src_configure() {
	econf \
		$(use_with gmp) \
		--without-mpir
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		python_execute rst2html.py Doc/pycrypt.rst > Doc/index.html || die "Generation of documentation failed"
		python_execute PYTHONPATH="$(ls -d build-$(PYTHON --ABI -f)/lib.*)" epydoc --config=Doc/epydoc-config --exclude-introspect="^Crypto\.(Random\.OSRNG\.nt|Util\.winrandom)$" || die "Generation of documentation failed"
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml Doc/apidoc/* Doc/index.html
	fi
}
