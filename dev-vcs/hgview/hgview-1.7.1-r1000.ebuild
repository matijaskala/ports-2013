# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"

inherit distutils

DESCRIPTION="Mercurial log navigator"
HOMEPAGE="http://www.logilab.org/project/hgview https://pypi.python.org/pypi/hgview"
SRC_URI="http://download.logilab.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="doc +qt4 urwid"
REQUIRED_USE="|| ( qt4 urwid )"

RDEPEND="$(python_abi_depend dev-vcs/mercurial)
	qt4? (
		$(python_abi_depend dev-python/docutils)
		$(python_abi_depend dev-python/PyQt4[X])
		$(python_abi_depend dev-python/qscintilla-python)
	)
	urwid? (
		$(python_abi_depend dev-python/pygments)
		$(python_abi_depend dev-python/pyinotify)
		$(python_abi_depend dev-python/urwid)
	)"
DEPEND="${RDEPEND}
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)"

# Workaround for missing passing of options to "build" command in src_install().
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
PYTHON_MODULES="hgext/hgview.py hgviewlib"

src_prepare() {
	# https://www.logilab.org/ticket/103668
	sed \
		-e 's:MANDIR=$(PREFIX)/man:MANDIR=$(PREFIX)/share/man:' \
		-e 's:$(INSTALL) $$i:$(INSTALL) -m 644 $$i:' \
		-i doc/Makefile

	distutils_src_prepare
}

src_compile() {
	distutils_src_compile $(use doc || echo --no-doc) $(use qt4 || echo --no-qt) $(use urwid || echo --no-curses)
}

src_install() {
	distutils_src_install $(use doc || echo --no-doc) $(use qt4 || echo --no-qt) $(use urwid || echo --no-curses)

	# Install Mercurial extension configuration file.
	insinto /etc/mercurial/hgrc.d
	doins hgext/hgview.rc
}
