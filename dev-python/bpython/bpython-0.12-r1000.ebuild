# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[ncurses]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit distutils

DESCRIPTION="Syntax highlighting and autocompletion for the Python interpreter"
HOMEPAGE="http://www.bpython-interpreter.org/ https://bitbucket.org/bobf/bpython https://pypi.python.org/pypi/bpython"
SRC_URI="http://www.bpython-interpreter.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc gtk nls urwid"

RDEPEND="$(python_abi_depend dev-python/pygments)
	$(python_abi_depend dev-python/setuptools)
	gtk? (
		$(python_abi_depend -e "3.* *-pypy-*" dev-python/pygobject:2)
		$(python_abi_depend -e "3.* *-pypy-*" dev-python/pygtk:2)
	)
	urwid? ( $(python_abi_depend dev-python/urwid) )"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )
	nls? ( $(python_abi_depend -e "3.1 3.2" dev-python/Babel) )"

DOCS="sample-config sample.theme light.theme"
PYTHON_MODULES="bpdb bpython"

src_prepare() {
	distutils_src_prepare
	sed -e "s/using_sphinx = True/using_sphinx = False/" -i setup.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		python_execute sphinx-build doc/sphinx/source doc/sphinx/html || die "Generation of documentation failed"
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/sphinx/html/
	fi

	if use gtk; then
		# pygtk does not support Python 3.
		rm -f "${ED}"usr/bin/bpython-gtk-3.*
	else
		rm -f "${ED}"usr/bin/bpython-gtk*

		delete_unneeded_modules() {
			rm -f "${ED}$(python_get_sitedir)/bpython/gtk_.py"
		}
		python_execute_function -q delete_unneeded_modules
	fi

	if ! use urwid; then
		rm -f "${ED}"usr/bin/bpython-urwid*

		delete_urwid() {
			rm -f "${ED}$(python_get_sitedir)/bpython/urwid.py"
		}
		python_execute_function -q delete_urwid
	fi
}
