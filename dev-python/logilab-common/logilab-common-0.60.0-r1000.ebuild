# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.3 3.4 *-jython"
PYTHON_NAMESPACES="logilab"

inherit distutils python-namespaces

DESCRIPTION="Useful miscellaneous modules used by Logilab projects"
HOMEPAGE="http://www.logilab.org/project/logilab-common https://pypi.python.org/pypi/logilab-common"
# SRC_URI="http://download.logilab.org/pub/common/${P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="doc test"

RDEPEND="$(python_abi_depend dev-python/setuptools)
	$(python_abi_depend -i "2.5 2.6 3.1" dev-python/unittest2)"
# Tests using dev-python/psycopg:2 are skipped when dev-python/psycopg:2 is not installed.
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc )
	test? (
		$(python_abi_depend -e "3.* *-jython *-pypy-*" dev-python/egenix-mx-base)
		!dev-python/psycopg:2[-mxdatetime]
	)"

S="${WORKDIR}/${P}"

PYTHON_MODULES="logilab"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		mkdir -p apidoc
		python_execute epydoc --parse-only -o apidoc --html -v --no-private --exclude=__pkginfo__ --exclude=setup --exclude=test -n "Logilab's common library" "$(ls -d ../build-$(PYTHON -f --ABI)/lib/logilab/common)" || die "Generation of documentation failed"
		popd > /dev/null
	fi
}

src_test() {
	testing() {
		local tpath="${T}/test-${PYTHON_ABI}"
		local spath="${tpath}${EPREFIX}$(python_get_sitedir)"

		python_execute "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --root="${tpath}" || die "Installation for tests failed with $(python_get_implementation_and_version)"

		# pytest uses tests placed relatively to the current directory.
		pushd "${spath}" > /dev/null || return
		python_execute PYTHONPATH="${spath}" "$(PYTHON)" "${tpath}${EPREFIX}/usr/bin/pytest" -v || return
		popd > /dev/null || return
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	python-namespaces_src_install

	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/pytest"

	doman doc/pytest.1

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/${PN/-//}/test"
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r doc/apidoc/
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	python-namespaces_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	python-namespaces_pkg_postrm
}
