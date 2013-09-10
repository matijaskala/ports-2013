# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils git-2

DESCRIPTION="Filesystem extended attributes for python"
HOMEPAGE="http://pyxattr.k1024.org/ https://github.com/iustin/pyxattr http://pypi.python.org/pypi/pyxattr"
SRC_URI=""
EGIT_REPO_URI="https://github.com/iustin/pyxattr"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-apps/attr"
DEPEND="${DEPEND}
	$(python_abi_depend dev-python/setuptools)"

src_prepare() {
	distutils_src_prepare
	sed -e "/extra_compile_args=/d" -i setup.py
}

src_test() {
	touch "${T}/test_file"
	if ! setfattr -n user.attr -v value "${T}/test_file" &> /dev/null; then
		ewarn "Skipping tests due to missing support for extended attributes in filesystem used by build directory"
		return
	fi

	distutils_src_test
}
