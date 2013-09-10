# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_BDEPEND="<<>>"
PYTHON_DEPEND="python? ( <<>> )"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython *-pypy-*"

inherit multilib python toolchain-funcs

MY_PN="Botan"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A C++ crypto library"
HOMEPAGE="http://botan.randombit.net/"
SRC_URI="http://files.randombit.net/botan/${MY_P}.tbz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="bindist bzip2 doc gmp python ssl threads zlib"

RDEPEND="bzip2? ( app-arch/bzip2:0= )
	gmp? ( dev-libs/gmp:0= )
	python? ( $(python_abi_depend dev-libs/boost:0=[python]) )
	ssl? ( dev-libs/openssl:0=[bindist=] )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -e "s/-Wl,-soname,\$@ //" -i src/build-data/makefile/python.in || die "sed failed"
	sed \
		-e "/DOCDIR/d" \
		-e "/^install:/s/ docs//" \
		-i src/build-data/makefile/unix_shr.in || die "sed failed"

	# Fix check for Sphinx version.
	sed \
		-e "/import sphinx/i\\    import re" \
		-e "s/version = map(int, sphinx.__version__.split('.'))/version = [int(getattr(re.match(r'\\\\d', x), 'group', lambda: '0')()) for x in sphinx.__version__.split('.')]/" \
		-i doc/conf.py

	# Fix compatibility with Python 3.
	sed -e "s/return map(int, gcc_version.split('.')\[0:2\])/return [int(x) for x in gcc_version.split('.')[0:2]]/" -i configure.py
	sed -e "s/_botan/.&/" -i src/wrap/python/__init__.py || die "sed failed"
}

src_configure() {
	local disable_modules="proc_walk,unix_procs,cpu_counter"
	use threads || disable_modules+=",pthreads"
	use bindist && disable_modules+=",ecdsa"
	elog "Disabling modules: ${disable_modules}"

	# Enable v9 instructions for sparc64
	if [[ "${PROFILE_ARCH}" = "sparc64" ]]; then
		CHOSTARCH="sparc32-v9"
	else
		CHOSTARCH="${CHOST%%-*}"
	fi

	local os
	case ${CHOST} in
		*-darwin*)   os=darwin ;;
		*)           os=linux  ;;
	esac

	./configure.py \
		--prefix="${EPREFIX}/usr" \
		--libdir=$(get_libdir) \
		--docdir=share/doc \
		--cc=gcc \
		--os=${os} \
		--cpu=${CHOSTARCH} \
		--with-endian="$(tc-endian)" \
		--without-sphinx \
		--with-tr1=system \
		$(use_with bzip2) \
		$(use_with gmp gnump) \
		$(use_with python boost-python) \
		$(use_with ssl openssl) \
		$(use_with zlib) \
		--disable-modules=${disable_modules} \
		|| die "configure.py failed"
}

src_compile() {
	emake CXX="$(tc-getCXX)" AR="$(tc-getAR) crs" LIB_OPT="${CXXFLAGS}" MACH_OPT=""

	if use doc; then
		einfo "Generation of documentation"
		sphinx-build doc html || die "Generation of documentation failed"
	fi

	if use python; then
		python_copy_sources build/python
		rm -fr build/python

		building() {
			rm -f build/python || return
			ln -s python-${PYTHON_ABI} build/python || return
			cp Makefile.python Makefile.python-${PYTHON_ABI} || return
			sed -e "s/-lboost_python/-lboost_python-${PYTHON_ABI}/" -i Makefile.python-${PYTHON_ABI} || return
			emake -f Makefile.python-${PYTHON_ABI} \
				CXX="$(tc-getCXX)" \
				CFLAGS="${CXXFLAGS}" \
				LDFLAGS="${LDFLAGS}" \
				PYTHON_ROOT="/usr/$(get_libdir)" \
				PYTHON_INC="-I$(python_get_includedir)"
		}
		python_execute_function building
	fi
}

src_test() {
	chmod -R ugo+rX "${S}"
	emake CXX="$(tc-getCXX)" CHECK_OPT="${CXXFLAGS}" check
	LD_LIBRARY_PATH="${S}" ./check --validate || die "Validation tests failed"
}

src_install() {
	emake DESTDIR="${ED}usr" install

	# Add compatibility symlinks.
	[[ -e "${ED}usr/bin/botan-config" ]] && die "Compatibility code no longer needed"
	[[ -e "${ED}usr/$(get_libdir)/pkgconfig/botan.pc" ]] && die "Compatibility code no longer needed"
	dosym botan-config-1.10 /usr/bin/botan-config
	dosym botan-1.10.pc /usr/$(get_libdir)/pkgconfig/botan.pc

	if use doc; then
		dohtml -r html/
	fi

	if use python; then
		installation() {
			rm -f build/python || return
			ln -s python-${PYTHON_ABI} build/python || return
			emake -f Makefile.python \
				PYTHON_SITE_PACKAGE_DIR="${ED}$(python_get_sitedir)" \
				install
		}
		python_execute_function installation
	fi
}

pkg_postinst() {
	if use python; then
		python_mod_optimize botan
	fi
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup botan
	fi
}
