# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit eutils python toolchain-funcs

DESCRIPTION="Python extension module generator for C and C++ libraries"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/sip/intro https://pypi.python.org/pypi/SIP"
if [[ ${PV} == *9999* ]]; then
	# Live version from mercurial repository
	EHG_REPO_URI="http://www.riverbankcomputing.com/hg/sip"
	inherit mercurial
elif [[ ${PV} == *_pre* ]]; then
	# Development snapshot
	HG_REVISION=
	MY_P=${PN}-${PV%_pre*}-snapshot-${HG_REVISION}
	SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
else
	# Official release
	SRC_URI="mirror://sourceforge/pyqt/${P}.tar.gz"
fi

LICENSE="|| ( GPL-2 GPL-3 sip )"
# Subslot based on SIP_API_MAJOR_NR from siplib/sip.h.in
SLOT="0/10"
KEYWORDS="*"
IUSE="debug doc"

DEPEND=""
RDEPEND=""
[[ ${PV} == *9999* ]] && DEPEND+="
	sys-devel/bison
	sys-devel/flex
	doc? (
		=dev-lang/python-2*
		$(python_abi_depend dev-python/sphinx)
	)
"

src_prepare() {
	if [[ ${PV} == *9999* ]]; then
		$(PYTHON -2) build.py prepare || die
		if use doc; then
			$(PYTHON -2) build.py doc || die
		fi
	fi

	epatch "${FILESDIR}/${PN}-4.9.3-darwin.patch"
	python_src_prepare
}

src_configure() {
	configuration() {
		local myconf=(
			"$(PYTHON)" configure.py
			--bindir="${EPREFIX}/usr/bin"
			--incdir="${EPREFIX}$(python_get_includedir)"
			--destdir="${EPREFIX}$(python_get_sitedir)"
			--sipdir="${EPREFIX}/usr/share/sip"
			$(use debug && echo --debug)
			AR="$(tc-getAR) cqs"
			CC="$(tc-getCC)"
			CFLAGS="${CFLAGS}"
			CFLAGS_RELEASE=
			CXX="$(tc-getCXX)"
			CXXFLAGS="${CXXFLAGS}"
			CXXFLAGS_RELEASE=
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			LFLAGS="${LDFLAGS}"
			LFLAGS_RELEASE=
			RANLIB=
			STRIP=
		)
		python_execute "${myconf[@]}"
	}
	python_execute_function -s configuration
}

src_install() {
	python_src_install

	dodoc NEWS

	if use doc; then
		dohtml -r doc/html/
	fi
}

pkg_postinst() {
	python_mod_optimize sipconfig.py sipdistutils.py
}

pkg_postrm() {
	python_mod_cleanup sipconfig.py sipdistutils.py
}
