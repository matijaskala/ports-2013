# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_DEPEND="<<[threads,ssl,xml]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.* *-jython *-pypy-*"

inherit bash-completion-r1 distutils eutils versionator

MY_P=${PN}-${PV}
SERIES=$(get_version_component_range 1-2)

DESCRIPTION="Bazaar is a next generation distributed version control system."
HOMEPAGE="http://bazaar-vcs.org/ http://pypi.python.org/pypi/bzr"
#SRC_URI="http://bazaar-vcs.org/releases/src/${MY_P}.tar.gz"
SRC_URI="http://launchpad.net/bzr/${SERIES}/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="curl doc +sftp test"

RDEPEND="curl? ( $(python_abi_depend dev-python/pycurl) )
	sftp? ( $(python_abi_depend dev-python/paramiko) )"

DEPEND="test? (
		${RDEPEND}
		$(python_abi_depend ">=dev-python/pyftpdlib-0.7.0")
		$(python_abi_depend dev-python/subunit)
		$(python_abi_depend ">=dev-python/testtools-0.9.5")
	)"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="doc/*.txt"
PYTHON_MODULES="bzrlib"

src_prepare() {
	distutils_src_prepare

	# Don't regenerate .c files from .pyx when Cython or Pyrex is found.
	epatch "${FILESDIR}/${PN}-2.4.2-no-pyrex-cython.patch"
}

src_test() {
	# Some tests expect the usual pyc compiling behaviour.
	python_enable_pyc

	# Define tests which are known to fail below.
	local skip_tests="("
	# https://bugs.launchpad.net/bzr/+bug/850676
	skip_tests+="per_transport.TransportTests.test_unicode_paths.*"
	skip_tests+=")"
	if [[ -n ${skip_tests} ]]; then
		einfo "Skipping tests known to fail: ${skip_tests}"
	fi

	testing() {
		LC_ALL="C" "$(PYTHON)" bzr --no-plugins selftest ${skip_tests:+-x} ${skip_tests}
	}
	python_execute_function testing

	# Just to make sure we don't hit any errors on later stages.
	python_disable_pyc
}

src_install() {
	distutils_src_install --install-data "${EPREFIX}/usr/share"

	if use doc; then
		docinto developers
		dodoc doc/developers/*
		for doc in mini-tutorial tutorials user-{guide,reference}; do
			docinto ${doc}
			dodoc doc/en/${doc}/*
		done
	fi

	dobashcomp contrib/bash/bzr
}
