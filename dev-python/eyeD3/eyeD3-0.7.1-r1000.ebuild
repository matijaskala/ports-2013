# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 2.6 3.* *-jython *-pypy-*"

inherit distutils

DESCRIPTION="Module for manipulating ID3 (v1 + v2) tags in Python"
HOMEPAGE="http://eyed3.nicfit.net/"
SRC_URI="http://eyed3.nicfit.net/releases/${P}.tgz"

LICENSE="GPL-2"
SLOT="0.7"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/paver)"
RDEPEND="!<${CATEGORY}/${PN}-0.6.18-r1:0"

DOCS="AUTHORS ChangeLog README.rst"
PYTHON_MODULES="eyed3"

src_prepare() {
	distutils_src_prepare

	cat << EOF > bin/eyeD3
#!/usr/bin/env python

import runpy
runpy.run_module("eyed3.main", run_name="__main__", alter_sys=True)
EOF

	sed -e "146,153d" -i pavement.py
}
