# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="python? ( <<2>> )"

inherit eutils python toolchain-funcs versionator

MY_PV="$(replace_all_version_separators _)"

DESCRIPTION="A system for large project software construction, which is simple to use and powerful."
HOMEPAGE="http://www.boost.org/doc/tools/build/index.html"
SRC_URI="mirror://sourceforge/boost/boost_${MY_PV}.tar.bz2"

LICENSE="Boost-1.0"
SLOT=0
KEYWORDS="~*"
IUSE="examples python test"
REQUIRED_USE="test? ( python )"

DEPEND="test? ( sys-apps/diffutils )"
RDEPEND=""

S="${WORKDIR}/boost_${MY_PV}/tools/build/v2"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_unpack() {
	tar xjpf "${DISTDIR}/${A}" boost_${MY_PV}/tools/build/v2 || die "Unpacking failed"
}

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-1.54.0-support_dots_in_python-buildid.patch" \
		"${FILESDIR}/${PN}-1.48.0-disable_python_rpath.patch" \
		"${FILESDIR}/${PN}-1.52.0-respect_flags.patch" \
		"${FILESDIR}/${PN}-1.54.0-fix_tests.patch"

	# Disable stripping.
	sed -e 's/ -s\b//' -i engine/build.jam || die "sed failed"

	# Force regeneration.
	rm engine/jambase.c || die

	# Allow full control of optimization and stripping flags when bjam is used as build system.
	sed \
		-e "s/^feature.feature optimization       : off speed space/& none/" \
		-e "s/^feature.feature debug-symbols      : on off/& none/" \
		-i tools/builtin.jam || die "sed failed"
}

src_configure() {
	if use python; then
		sed -e "s/2.7 2.6 2.5 2.4 2.3 2.2/$(python_get_version)/" -i engine/build.jam || die "sed failed"
	fi
}

src_compile() {
	cd engine

	CC="$(tc-getCC)" ./build.sh cc -d+2 $(use_with python python "${EPREFIX}/usr") || die "Building of bjam failed"
}

src_test() {
	cd test

	DO_DIFF="1" "$(PYTHON)" test_all.py
	if [[ -s test_results.txt ]]; then
		eerror "Tests failed: $(<test_results.txt)"
		die "Tests failed"
	fi
}

src_install() {
	dobin engine/bin.*/{b2,bjam}

	insinto /usr/share/boost-build
	doins -r "${FILESDIR}/site-config.jam" \
		boost-build.jam bootstrap.jam build-system.jam user-config.jam *.py \
		build kernel options tools util

	# Delete invalid file.
	rm "${ED}usr/share/boost-build/build/project.ann.py" || die

	if ! use python; then
		rm "${ED}usr/share/boost-build/"**/*.py || die
	fi

	dodoc changes.txt hacking.txt release_procedure.txt notes/build_dir_option.txt notes/relative_source_paths.txt

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r example/*
	fi
}

pkg_postinst() {
	use python && python_mod_optimize /usr/share/boost-build
}

pkg_postrm() {
	use python && python_mod_cleanup /usr/share/boost-build
}
