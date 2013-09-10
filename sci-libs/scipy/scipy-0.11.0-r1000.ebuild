# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"

inherit distutils eutils flag-o-matic fortran-2 multilib toolchain-funcs

MY_P="${PN}-${PV/_/}"
DOC_P="${PN}-0.11.0"

DESCRIPTION="Scientific algorithms library for Python"
HOMEPAGE="http://www.scipy.org/ https://github.com/scipy/scipy https://pypi.python.org/pypi/scipy"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	doc? (
		http://docs.scipy.org/doc/${DOC_P}/${PN}-html.zip -> ${DOC_P}-html.zip
		http://docs.scipy.org/doc/${DOC_P}/${PN}-ref.pdf -> ${DOC_P}-ref.pdf
	)"

LICENSE="BSD LGPL-2"
SLOT="0"
IUSE="doc test umfpack"
KEYWORDS="*"

CDEPEND="$(python_abi_depend dev-python/numpy[lapack])
	sci-libs/arpack
	virtual/cblas
	virtual/lapack
	umfpack? ( sci-libs/umfpack )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	test? ( $(python_abi_depend dev-python/nose) )
	umfpack? ( dev-lang/swig )"
RDEPEND="${CDEPEND}
	$(python_abi_depend -i "2.[67]" dev-python/imaging)"

S="${WORKDIR}/${MY_P}"

DOCS="THANKS.txt LATEST.txt TOCHANGE.txt"

pkg_setup() {
	fortran-2_pkg_setup
	python_pkg_setup
}

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use doc; then
		unzip -qo "${DISTDIR}/${DOC_P}-html.zip" -d html || die
	fi
}

pc_incdir() {
	$(tc-getPKG_CONFIG) --cflags-only-I $@ | \
		sed -e 's/^-I//' -e 's/[ ]*-I/:/g'
}

pc_libdir() {
	$(tc-getPKG_CONFIG) --libs-only-L $@ | \
		sed -e 's/^-L//' -e 's/[ ]*-L/:/g'
}

pc_libs() {
	$(tc-getPKG_CONFIG) --libs-only-l $@ | \
		sed -e 's/[ ]-l*\(pthread\|m\)[ ]*//g' \
		-e 's/^-l//' -e 's/[ ]*-l/,/g'
}

src_prepare() {
	local libdir="${EPREFIX}"/usr/$(get_libdir)

	# scipy automatically detects libraries by default
	export {FFTW,FFTW3,UMFPACK}=None
	use umfpack && unset UMFPACK
	# the missing symbols are in -lpythonX.Y, but since the version can
	# differ, we just introduce the same scaryness as on Linux/ELF
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared
	[[ -z ${FC}  ]] && export FC="$(tc-getFC)"
	# hack to force F77 to be FC until bug #278772 is fixed
	[[ -z ${F77} ]] && export F77="$(tc-getFC)"
	export F90="${FC}"
	export SCIPY_FCONFIG="config_fc --noopt --noarch"
	append-fflags -fPIC

	cat >> site.cfg <<-EOF
		[blas]
		include_dirs = $(pc_incdir cblas)
		library_dirs = $(pc_libdir cblas blas):${libdir}
		blas_libs = $(pc_libs cblas blas)
		[lapack]
		library_dirs = $(pc_libdir lapack):${libdir}
		lapack_libs = $(pc_libs lapack)
	EOF
}

src_compile() {
	distutils_src_compile ${SCIPY_FCONFIG}
}

src_test() {
	testing() {
		python_execute "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --home="${S}/test-${PYTHON_ABI}" --no-compile ${SCIPY_FCONFIG} || die "Installation for tests failed with $(python_get_implementation_and_version)"
		pushd "${S}/test-${PYTHON_ABI}/"lib*/python > /dev/null
		python_execute PYTHONPATH="." "$(PYTHON)" -c "import scipy, sys; sys.exit(not scipy.test('full', verbose=3).wasSuccessful())" || return
		popd > /dev/null
		rm -fr test-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install ${SCIPY_FCONFIG}

	delete_incompatible_modules() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			# scipy.weave supports only Python 2.
			rm -fr "${ED}$(python_get_sitedir)/scipy/weave"
		fi
	}
	python_execute_function -q delete_incompatible_modules

	if use doc; then
		dohtml -r "${WORKDIR}/html/"*
		dodoc "${DISTDIR}/${DOC_P}-ref.pdf"
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	elog "You might want to set the variable SCIPY_PIL_IMAGE_VIEWER"
	elog "to your prefered image viewer if you don't like the default one. Ex:"
	elog "\t echo \"export SCIPY_PIL_IMAGE_VIEWER=display\" >> ~/.bashrc"
}
