# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-exec/python-exec-2.9999.ebuild,v 1.2 2013/10/03 21:07:20 mgorny Exp $

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="http://bitbucket.org/mgorny/${PN}.git"
EGIT_BRANCH="python-exec2"

inherit git-2
#endif

# Kids, don't do this at home!
inherit python-utils-r1
PYTHON_COMPAT=( "${_PYTHON_ALL_IMPLS[@]}" )

inherit autotools-utils python-r1 versionator

DESCRIPTION="Python script wrapper"
HOMEPAGE="https://bitbucket.org/mgorny/python-exec/"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

#if LIVE
KEYWORDS=
SRC_URI=
#endif

src_configure() {
	local pyimpls i EPYTHON
	for i in "${PYTHON_COMPAT[@]}"; do
		python_export "${i}" EPYTHON
		pyimpls+=" ${EPYTHON}"
	done

	local myeconfargs=(
		--with-eprefix="${EPREFIX}"
		--with-python-impls="${pyimpls}"
	)

	autotools-utils_src_configure
}

cleanup_vardb_deps() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		# if 2.0-r1+ was installed already, no need for cleaning up again.
		if version_is_at_least 2.0-r1 ${v}; then
			return 0
		fi
	done

	local f files=()
	for f in "${EROOT%/}"/var/db/pkg/*/*/*DEPEND; do
		if grep -q 'dev-python/python-exec\[' "${f}"; then
			files+=( "${f}" )
		fi
	done

	if [[ ${files[@]} ]]; then
		ebegin "Fixing unslotted python-exec dependencies in installed packages"
		sed -i -e 's,dev-python/python-exec\[,dev-python/python-exec:0[,' \
			"${files[@]}"
		eend ${?}
	fi
}

pkg_postinst() {
	cleanup_vardb_deps
}
