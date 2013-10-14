# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="Sphinx"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python documentation generator"
HOMEPAGE="http://sphinx-doc.org/ https://bitbucket.org/birkenfeld/sphinx https://pypi.python.org/pypi/Sphinx"
if [[ "${PV}" == *_pre* ]]; then
	SRC_URI="http://people.apache.org/~Arfrever/gentoo/${MY_P}.tar.xz"
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
fi

# Main license: BSD-2
LICENSE="BSD BSD-2 MIT PSF-2 test? ( ElementTree )"
SLOT="0"
KEYWORDS="*"
IUSE="doc latex test"

DEPEND="$(python_abi_depend dev-python/docutils)
	$(python_abi_depend dev-python/jinja)
	$(python_abi_depend dev-python/pygments)
	$(python_abi_depend dev-python/setuptools)
	latex? (
		app-text/dvipng
		dev-texlive/texlive-latexextra
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES"

src_prepare() {
	distutils_src_prepare

	# Accept new versions of Jinja with Python 3.1 and 3.2.
	sed -e "s/requires.append('Jinja2>=2.3,<2.7')/requires.append('Jinja2>=2.3')/" -i setup.py

	# Disable failing test.
	# https://bitbucket.org/birkenfeld/sphinx/issue/1268
	sed \
		-e "s/from util import .*/&, skip_if/" \
		-e "/test_build_sphinx_with_nonascii_path/i\\@skip_if(sys.version_info[0] == 2)" \
		-i tests/test_setup_command.py

	prepare_tests() {
		cp -r tests tests-${PYTHON_ABI}

		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			2to3-${PYTHON_ABI} -nw --no-diffs tests-${PYTHON_ABI}
		fi
	}
	python_execute_function prepare_tests
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		sed -e "/import sys/a sys.path.insert(0, '${S}/build-$(PYTHON -f --ABI)/lib')" -i sphinx-build.py || die "sed failed"
		pushd doc > /dev/null
		emake SPHINXBUILD="$(PYTHON -f) ../sphinx-build.py" html
		popd > /dev/null
	fi
}

src_test() {
	python_execute_nosetests -e -P 'build-${PYTHON_ABI}/lib' -- -w 'tests-${PYTHON_ABI}'
}

src_install() {
	distutils_src_install
	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/sphinx-build"

	delete_grammar_pickle() {
		rm -f "${ED}$(python_get_sitedir)/sphinx/pycode/Grammar$(python_get_version -l).pickle"
	}
	python_execute_function -q delete_grammar_pickle

	if use doc; then
		dohtml -A txt -r doc/_build/html/
	fi
}

pkg_postinst() {
	distutils_pkg_postinst

	# Generate the Grammar pickle to avoid sandbox violations.
	generate_grammar_pickle() {
		"$(PYTHON)" -c "import sys; sys.path.insert(0, '${EROOT}$(python_get_sitedir -b)'); from sphinx.pycode.pgen2.driver import load_grammar; load_grammar('${EROOT}$(python_get_sitedir -b)/sphinx/pycode/Grammar.txt')"
	}
	python_execute_function \
		--action-message 'Generation of Grammar pickle with $(python_get_implementation_and_version)...' \
		--failure-message 'Generation of Grammar pickle with $(python_get_implementation_and_version) failed' \
		generate_grammar_pickle
}

pkg_postrm() {
	distutils_pkg_postrm

	delete_grammar_pickle() {
		rm -f "${EROOT}$(python_get_sitedir -b)/sphinx/pycode/Grammar$(python_get_version -l).pickle" || return

		# Delete empty parent directories.
		local dir="${EROOT}$(python_get_sitedir -b)/sphinx/pycode"
		while [[ "${dir}" != "${EROOT%/}" ]]; do
			rmdir "${dir}" 2> /dev/null || break
			dir="${dir%/*}"
		done
	}
	python_execute_function \
		--action-message 'Deletion of Grammar pickle with $(python_get_implementation_and_version)...' \
		--failure-message 'Deletion of Grammar pickle with $(python_get_implementation_and_version) failed' \
		delete_grammar_pickle
}
