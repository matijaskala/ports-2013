# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[ncurses]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.1 *-pypy-*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Urwid is a curses-based user interface library for Python"
HOMEPAGE="http://excess.org/urwid/ https://pypi.python.org/pypi/urwid"
SRC_URI="http://excess.org/urwid/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples glib test twisted"
REQUIRED_USE="test? ( glib twisted )"

RDEPEND="glib? ( $(python_abi_depend -i "2.*" dev-python/pygobject:2) )
	twisted? ( $(python_abi_depend -i "2.*" dev-python/twisted-core) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	distutils_src_prepare

	# urwid.str_util extension module is incompatible with PyPy.
	sed \
		-e "/import os/a import platform" \
		-e "/'ext_modules':/s:\[Extension('urwid.str_util', sources=\['source/str_util.c'\])\]:& if not (hasattr(platform, \"python_implementation\") and platform.python_implementation() == \"PyPy\") else []:" \
		-i setup.py

	# Fix AttributeError during generation of documentation with Python 3.
	sed -e "/^FILE_PATH =/s/\.decode('utf-8')//" -i docs/conf.py

	if [[ "$(python_get_version -f --major)" == "3" ]]; then
		2to3-$(PYTHON -f --ABI) -nw --no-diffs docs/conf.py
	fi
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		python_execute PYTHONPATH="$(ls -d ../build-$(PYTHON -f --ABI)/lib*)" sphinx-build . _build/html || die "Generation of documentation failed"
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/_build/html/
	fi

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
