# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/newt/newt-0.52.15.ebuild,v 1.4 2013/10/03 08:25:46 naota Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils multilib python-r1 autotools toolchain-funcs

DESCRIPTION="Redhat's Newt windowing toolkit development files"
HOMEPAGE="https://fedorahosted.org/newt/"
SRC_URI="https://fedorahosted.org/releases/n/e/newt/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gpm tcl nls"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/popt-1.6
	=sys-libs/slang-2*
	elibc_uclibc? ( sys-libs/ncurses )
	gpm? ( sys-libs/gpm )
	tcl? ( >=dev-lang/tcl-8.5 )
	"
DEPEND="${RDEPEND}"

src_prepare() {
	# bug 73850
	if use elibc_uclibc; then
		sed -i -e 's:-lslang:-lslang -lncurses:g' Makefile.in || die
	fi

	sed -i Makefile.in \
		-e 's|-ltcl8.4|-ltcl|g' \
		-e 's|$(SHCFLAGS) -o|$(LDFLAGS) &|g' \
		-e 's|-g -o|$(CFLAGS) $(LDFLAGS) -o|g' \
		-e 's|-shared -o|$(CFLAGS) $(LDFLAGS) &|g' \
		-e 's|instroot|DESTDIR|g' \
		-e 's|	make |	$(MAKE) |g' \
		-e "s|	ar |	$(tc-getAR) |g" \
		|| die "sed Makefile.in"

	local langs=""
	if [ -n "${LINGUAS}" ]; then
		for lang in ${LINGUAS}; do
			test -r po/${lang}.po && langs="${langs} ${lang}.po"
		done
		sed -i po/Makefile \
			-e "/^CATALOGS = /cCATALOGS = ${langs}" \
			|| die "sed po/Makefile"
	fi

	epatch "${FILESDIR}"/${PN}-0.52.13-gold.patch \
		"${FILESDIR}"/${PN}-0.52.15-snack.patch \
		"${FILESDIR}"/${PN}-0.52.14-tcl.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with gpm gpm-support) \
		$(use_with tcl) \
		$(use_enable nls)
}

python_compile() {
	emake PYTHONVERS="${PYTHON}" || die "emake failed"
}

python_install() {
	emake \
		DESTDIR="${D}" \
		PYTHONVERS="${PYTHON}" \
		install || die "make install failed"
	python_optimize
}

python_install_all() {
	dodoc peanuts.py popcorn.py tutorial.sgml
	doman whiptail.1
}
